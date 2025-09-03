#!/usr/bin/env python3
"""
Direct MOL2 to VASP converter.
This script manually parses MOL2 files and writes VASP format directly.
No external dependencies required.
"""

import re
import sys
from collections import Counter
import math

def parse_mol2_crystal_info(content):
    """Parse crystal information from @<TRIPOS>CRYSIN section."""
    crysin_match = re.search(r'@<TRIPOS>CRYSIN\s*\n\s*([^\n]+)', content)
    
    if not crysin_match:
        raise ValueError("No @<TRIPOS>CRYSIN section found in MOL2 file")
    
    crysin_line = crysin_match.group(1).strip()
    values = crysin_line.split()
    
    if len(values) < 6:
        raise ValueError(f"Invalid CRYSIN line: {crysin_line}")
    
    a = float(values[0])
    b = float(values[1]) 
    c = float(values[2])
    alpha = float(values[3])
    beta = float(values[4])
    gamma = float(values[5])
    
    return a, b, c, alpha, beta, gamma

def parse_mol2_atoms(content):
    """Parse atomic information from @<TRIPOS>ATOM section."""
    atom_section_match = re.search(r'@<TRIPOS>ATOM\s*\n(.*?)(?=@<TRIPOS>|$)', content, re.DOTALL)
    
    if not atom_section_match:
        raise ValueError("No @<TRIPOS>ATOM section found in MOL2 file")
    
    atom_section = atom_section_match.group(1).strip()
    atom_lines = atom_section.split('\n')
    
    atoms = []
    
    for line in atom_lines:
        line = line.strip()
        if not line:
            continue
            
        # Parse: index name x y z type res_id res_name charge
        parts = line.split()
        if len(parts) >= 7:
            try:
                element = parts[5]  # element type (6th column, 0-indexed)
                # Clean up element symbol (remove numbers and dots)
                element = re.sub(r'[0-9.]', '', element)
                
                x = float(parts[2])  # X coordinate
                y = float(parts[3])  # Y coordinate  
                z = float(parts[4])  # Z coordinate
                
                atoms.append({
                    'element': element,
                    'x': x,
                    'y': y,
                    'z': z
                })
                
            except (ValueError, IndexError) as e:
                print(f"Warning: Skipping malformed atom line: {line}")
                continue
    
    if not atoms:
        raise ValueError("No valid atoms found in MOL2 file")
    
    return atoms

def create_unit_cell_matrix(a, b, c, alpha, beta, gamma):
    """Create unit cell matrix from lattice parameters."""
    
    # Convert angles to radians
    alpha_rad = math.radians(alpha)
    beta_rad = math.radians(beta)
    gamma_rad = math.radians(gamma)
    
    # Calculate unit cell vectors
    # a vector along x-axis
    ax = a
    ay = 0.0
    az = 0.0
    
    # b vector in xy-plane
    bx = b * math.cos(gamma_rad)
    by = b * math.sin(gamma_rad)
    bz = 0.0
    
    # c vector
    cx = c * math.cos(beta_rad)
    cy = c * (math.cos(alpha_rad) - math.cos(beta_rad) * math.cos(gamma_rad)) / math.sin(gamma_rad)
    cz = c * math.sqrt(1 - math.cos(alpha_rad)**2 - math.cos(beta_rad)**2 - math.cos(gamma_rad)**2 + 
                     2 * math.cos(alpha_rad) * math.cos(beta_rad) * math.cos(gamma_rad)) / math.sin(gamma_rad)
    
    return [
        [ax, ay, az],
        [bx, by, bz], 
        [cx, cy, cz]
    ]

def write_vasp_file(atoms, cell_matrix, output_file):
    """Write structure to VASP format."""
    
    # Count atoms by element
    element_counts = Counter(atom['element'] for atom in atoms)
    
    # Sort elements by atomic number (approximate order)
    element_order = ['H', 'He', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Ne', 
                     'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl', 'Ar', 'K', 'Ca',
                     'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn',
                     'Ga', 'Ge', 'As', 'Se', 'Br', 'Kr', 'Rb', 'Sr', 'Y', 'Zr',
                     'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn',
                     'Sb', 'Te', 'I', 'Xe', 'Cs', 'Ba', 'La', 'Ce', 'Pr', 'Nd',
                     'Pm', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm', 'Yb',
                     'Lu', 'Hf', 'Ta', 'W', 'Re', 'Os', 'Ir', 'Pt', 'Au', 'Hg',
                     'Tl', 'Pb', 'Bi', 'Po', 'At', 'Rn', 'Fr', 'Ra', 'Ac', 'Th',
                     'Pa', 'U', 'Np', 'Pu', 'Am', 'Cm', 'Bk', 'Cf', 'Es', 'Fm']
    
    # Sort elements by the order above
    sorted_elements = sorted(element_counts.keys(), key=lambda x: element_order.index(x) if x in element_order else 999)
    
    with open(output_file, 'w') as f:
        # Title line
        f.write("TECXOS\n")
        
        # Scaling factor
        f.write("1.0\n")
        
        # Unit cell vectors
        for row in cell_matrix:
            f.write(f"{row[0]:20.16f} {row[1]:20.16f} {row[2]:20.16f}\n")
        
        # Element symbols
        f.write(" ".join(sorted_elements) + "\n")
        
        # Atom counts
        f.write(" ".join(str(element_counts[element]) for element in sorted_elements) + "\n")
        
        # Coordinate type
        f.write("Cartesian\n")
        
        # Atomic coordinates
        for element in sorted_elements:
            for atom in atoms:
                if atom['element'] == element:
                    f.write(f"{atom['x']:20.16f} {atom['y']:20.16f} {atom['z']:20.16f}\n")

def convert_mol2_to_vasp(input_mol2, output_vasp):
    """Convert MOL2 file to VASP format."""
    print(f"Reading MOL2 file: {input_mol2}")
    
    # Read the entire file
    with open(input_mol2, 'r') as f:
        content = f.read()
    
    # Parse crystal information
    try:
        a, b, c, alpha, beta, gamma = parse_mol2_crystal_info(content)
        print(f"Crystal parameters: a={a:.4f}, b={b:.4f}, c={c:.4f}")
        print(f"Angles: α={alpha:.2f}°, β={beta:.2f}°, γ={gamma:.2f}°")
    except Exception as e:
        print(f"Error parsing crystal info: {e}")
        sys.exit(1)
    
    # Parse atomic structure
    try:
        atoms = parse_mol2_atoms(content)
        print(f"Read {len(atoms)} atoms")
    except Exception as e:
        print(f"Error parsing atomic structure: {e}")
        sys.exit(1)
    
    # Create unit cell matrix
    cell_matrix = create_unit_cell_matrix(a, b, c, alpha, beta, gamma)
    print("Unit cell matrix:")
    for i, row in enumerate(cell_matrix):
        print(f"  {row[0]:10.6f} {row[1]:10.6f} {row[2]:10.6f}")
    
    # Write VASP file
    print(f"Writing VASP file: {output_vasp}")
    write_vasp_file(atoms, cell_matrix, output_vasp)
    print("✅ Conversion completed successfully!")
    
    # Print verification info
    element_counts = Counter(atom['element'] for atom in atoms)
    print(f"\nVerification:")
    print(f"Unit cell volume: {a * b * c * (1 - math.cos(math.radians(alpha))**2 - math.cos(math.radians(beta))**2 - math.cos(math.radians(gamma))**2 + 2*math.cos(math.radians(alpha))*math.cos(math.radians(beta))*math.cos(math.radians(gamma)))**0.5:.2f} Å³")
    print(f"Number of atoms: {len(atoms)}")
    print(f"Chemical composition: {dict(element_counts)}")

def main():
    # Configuration
    input_file = "0.mol2"
    output_file = "0_fixed.vasp"
    
    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    
    try:
        convert_mol2_to_vasp(input_file, output_file)
    except Exception as e:
        print(f"❌ Conversion failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
