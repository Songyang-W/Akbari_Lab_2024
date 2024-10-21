#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 23:44:13 2024
code used for clustering the cFos data
@author: songyangwang
"""

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.utils.class_weight import compute_class_weight
import matplotlib.pyplot as plt

# Load the .mat file and extract data
import scipy.io
file_path = '/Users/songyangwang/repos/Akbari_Lab_2024/cFos_data_summary.mat'
mat_contents = scipy.io.loadmat(file_path)

# Extract variables
ca1 = np.array(mat_contents['ca1']).flatten()
ca3 = np.array(mat_contents['ca3']).flatten()
cmro2mat = np.array(mat_contents['cmro2mat'])

# Prepare the data: 
# Each row in cmro2mat represents an animal, and we need to create labels (0 = CA1, 1 = CA3)
labels = np.concatenate([np.zeros_like(ca1), np.ones_like(ca3)])  # CA1 as 0, CA3 as 1
features = np.vstack([cmro2mat, cmro2mat])  # Stack CMRO2 data for both CA1 and CA3

# Split into train and test sets (80% train, 20% test)
X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.1, random_state=42)

# Check class balance and compute class weights
class_weights = compute_class_weight(class_weight='balanced', classes=np.unique(y_train), y=y_train)
class_weight_dict = {0: class_weights[0], 1: class_weights[1]}

# Train a Random Forest classifier with class weights to address any imbalance
model = RandomForestClassifier(class_weight=class_weight_dict, random_state=42)
model.fit(X_train, y_train)

# Make predictions on the test set
y_pred = model.predict(X_test)

# Evaluate the model
accuracy = accuracy_score(y_test, y_pred)
# classification_rep = classification_report(y_test, y_pred, target_names=["CA1", "CA3"])

# Print results
print(f"Accuracy: {accuracy}")
# print(f"Classification Report: \n{classification_rep}")