# /// script
# requires-python = ">=3.12,<3.13"
# dependencies = [
#   "numpy>2",
#   "tifffile",
#   "imagecodecs",
#   "polars",
#   "scipy",
#   "scikit-learn",
# ]
# [tool.uv]
# exclude-newer = "2025-04-24T00:00:00Z"
# ///
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--input_df_input")
parser.add_argument("--output_df_output")
parser.add_argument("--params_parameter_1", type=float, default=0.5)
args = parser.parse_args()

df_input_filename = args.input_df_input

df_output_filename = args.output_df_output

parameter_1 = args.params_parameter_1
