function p_vector = Permutation_test_loop(data1,data2,no_permutation)
size1 = size(data1);
size2 = size(data2);

data_length = max(size1);
data1_size = min(size1);
data2_size = min(size2);

p_vector = ones(1, data_length);

for i = 1:data_length
    p_vector(i) = permutationTest(data1(i,:), data2(i,:),no_permutation);
end

end

