function p_vector = M_W_U_test_loop(data1,data2)

size1 = size(data1);
size2 = size(data2);

data_length = max(size1);
data1_size = min(size1);
data2_size = min(size2);

p_vector = ones(1, data_length);

for i = 1:data_length
    p_vector(i) = ranksum(data1(i,:), data2(i,:));
end


%{
p_matrix = ones(data1_size,data2_size);

for group1_no = 1:data1_size
    for group2_no = 1:data2_size
        p_matrix(group1_no,group2_no) = ranksum(data1(:,group1_no), data2(:,group2_no));
    end
end
%}

end