function [slope_matrix,intersect_matrix,new_time]=Slope_trend(time,data,window_size,overlap)

fs = 100;%hz
time_resize = buffer(time,window_size*fs,overlap*fs);
time_resize(:,[1,end]) = []; %remove the first column and the last column due to lot of 0
new_time = mean(time_resize);

for subject = 1:size(data,2)
    %for each subject, do resize and calculate the slope trend
    data_resize = buffer(data(:,subject),window_size*fs,overlap*fs);
    data_resize(:,[1,end])=[];

    for slope_no = 1:size(time_resize,2)
        p(slope_no,:) = polyfit(time_resize(:,slope_no),data_resize(:,slope_no),1);
        slope_matrix(slope_no,subject)=p(slope_no,1);
        intersect_matrix(slope_no,subject) = p(slope_no,2);
        % slope and intersect are saved as: column:subject, row:slope at
        % different time points
    end
end

end