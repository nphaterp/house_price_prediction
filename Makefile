# house price prediction pipeline
# author: Tejas and Neel Phaterpekar

all: data/cleaned_train.csv \
data/X_train.csv \
data/X_valid.csv \
data/y_train.csv \
data/y_valid.csv \
data/X_train_scaled.csv \
models/dummy_reg.pkl \
results/model_table.csv

# Deal with missing data
data/cleaned_train.csv: src/fill_missing.py
	python src/fill_missing.py --train_path=data/train.csv



# Splits the data
data/X_train.csv data/X_valid.csv data/y_train.csv data/y_valid.csv: src/split_data.py data/cleaned_train.csv
	python src/split_data.py --clean_train_path=data/cleaned_train.csv

# Preprocessing Step
data/X_train_scaled.csv data/X_valid_scaled.csv: src/preprocessor.py data/X_train.csv data/X_valid.csv
	python src/preprocessor.py

# Train Models
models/dummy_reg.pkl: data/X_train.csv data/X_valid.csv data/y_train.csv data/y_valid.csv
	python src/baseline_score.py

# Create Results Table for models
results/model_table.csv: src/model_table_init.py models/dummy_reg.pkl
	python src/model_table_init.py

# Remove all files
clean:
	rm -rf data/cleaned_train.csv
	rm -rf data/X_train.csv
	rm -rf data/X_valid.csv
	rm -rf data/y_train.csv
	rm -rf data/y_valid.csv
	rm -rf models/dummy_reg.pkl
	rm -rf models/model_table.csv