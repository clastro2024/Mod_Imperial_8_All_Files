import zipfile
import os

def decrypt_pak_file(input_file, output_file):
    # Read the entire input file
    with open(input_file, 'rb') as f_in:
        encrypted_data = f_in.read()

    # Decrypt the data
    decrypted_data = bytes([byte ^ 0xAB for byte in encrypted_data])

    # Write the decrypted data to a temporary file
    temp_file = f"{output_file}.tmp"
    with open(temp_file, 'wb') as f_out:
        f_out.write(decrypted_data)

    # Check if the decrypted file is a valid ZIP archive
    try:
        with zipfile.ZipFile(temp_file, 'r') as zip_ref:
            zip_ref.extractall(f"./decrypted/{output_file}")
        
        print(f"Successfully unzipped {input_file}")
    except zipfile.BadZipFile:
        try:
            with zipfile.ZipFile(input_file, 'r') as zip_ref:
                zip_ref.extractall(f"./decrypted/{output_file}")
            
            print(f"Successfully unzipped {input_file}")
        except zipfile.BadZipFile:
            print(f"Failed to unzip {input_file}. It may corrupted.")
    finally:
        # Remove the temporary file
        os.remove(temp_file)

def main():
    pak_files = [f for f in os.listdir('./paks') if f.endswith('.pak') or f.endswith('.pat') or f.endswith('.bak')]
    
    for pak_file in pak_files:
        output_dir = pak_file[:-4]  # Remove '.pak' extension
        decrypt_pak_file(f"./paks/{pak_file}", output_dir)

if __name__ == "__main__":
    main()