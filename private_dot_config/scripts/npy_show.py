# /// script
# dependencies = [
#   "numpy",
#   "humanize",
# ]
# ///
# -*- coding: utf-8 -*-
"""
A utility script to inspect and print metadata of a NumPy (.npy) file.

This script takes the path to a .npy file as a command-line argument,
loads the array, and prints various details about it, such as its shape,
data type, memory usage, and basic statistics.

Usage:
    uv run ~/.config/scripts/npy_show.py /path/to/your/file.npy
"""

import argparse
import os
import sys

import humanize
import numpy as np


def analyze_npy_file(file_path):
    """
    Loads a .npy file and prints its metadata.

    Args:
        file_path (str): The path to the .npy file.
    """
    try:
        # --- File Validation ---
        if not os.path.exists(file_path):
            print(f"Error: File not found at '{file_path}'", file=sys.stderr)
            sys.exit(1)

        print(f"--- Analyzing NumPy File: {os.path.basename(file_path)} ---")
        print(f"Full Path: {os.path.abspath(file_path)}")

        # --- Load Array ---
        data = np.load(file_path)
        print("\n[ Array Metadata ]")

        # --- Print Basic Info ---
        print(f"  - Shape: {data.shape}")
        print(f"  - Dimensions: {data.ndim}")
        print(f"  - Data Type (dtype): {data.dtype}")
        print(f"  - Total Elements (size): {data.size:,}")
        print(f"  - Memory Usage: {humanize.naturalsize(data.nbytes)}")

        # --- Statistics for Numeric Data ---
        if np.issubdtype(data.dtype, np.number):
            print("\n[ Numeric Statistics ]")
            print(f"  - Minimum Value: {np.min(data)}")
            print(f"  - Maximum Value: {np.max(data)}")
            print(f"  - Mean: {np.mean(data):.4f}")
            print(f"  - Standard Deviation: {np.std(data):.4f}")
            print(f"  - Median: {np.median(data):.4f}")
        else:
            print("\n[ Numeric Statistics ]")
            print("  - (Skipped: Array does not contain numeric data)")

        # --- Unique Values ---
        print("\n[ Unique Values ]")
        try:
            unique_values = np.unique(data)
            num_unique = len(unique_values)
            print(f"  - Count of Unique Values: {num_unique}")

            # To avoid flooding the console, only show a sample of unique values
            if num_unique > 15:
                print(f"  - First 15 Unique Values: {unique_values[:15]}")
            else:
                print(f"  - Values: {unique_values}")
        except TypeError:
            # This can happen with complex object types
            print("  - Could not determine unique values (likely complex object type).")

        print("\n--- Analysis Complete ---")

    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.", file=sys.stderr)
        sys.exit(1)
    except ValueError as e:
        print(
            f"Error: Could not load the file. It may be corrupted or not a valid .npy file.",
            file=sys.stderr,
        )
        print(f"Details: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    """
    Parses command-line arguments and initiates the analysis.
    """
    parser = argparse.ArgumentParser(
        description="Inspect a NumPy (.npy) file and print its metadata.",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument(
        "file_path", type=str, help="The full path to the .npy file to be analyzed."
    )
    args = parser.parse_args()
    analyze_npy_file(args.file_path)


if __name__ == "__main__":
    main()
