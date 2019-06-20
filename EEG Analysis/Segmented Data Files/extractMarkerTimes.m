function [array1,array2,array3,array4,array5,array6,array7,mask,resp,endTrial] ...
    = extractMarkerTimes(dataExp)

markers = dataExp{2}.time_series(5,:);
time_stamps = dataExp{2}.time_stamps;
nMarkers = length(markers);

% Array 1 markers
a = 1;
array1 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 0 && markers(i+1) == 1
        array1(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% Array 2 markers
a = 1;
array2 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 1 && markers(i+1) == 2
        array2(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% Array 3 markers
a = 1;
array3 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 2 && markers(i+1) == 3
        array3(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% Array 4 markers
a = 1;
array4 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 3 && markers(i+1) == 4
        array4(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% Array 5 markers
a = 1;
array5 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 4 && markers(i+1) == 5
        array5(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% Array 6 markers
a = 1;
array6 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 5 && markers(i+1) == 6
        array6(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% Array 7 markers
a = 1;
array7 = zeros(1,32);
for i = 1:nMarkers
    if markers(i) == 6 && markers(i+1) == 7
        array7(a) = time_stamps(i+1);
        a = a + 1;
    end
end

% % Mask markers
% a = 1;
% mask = zeros(1,128);
% for i = 1:nMarkers
%     if markers(i) == 7 && markers(i+1) == 8
%         mask(a) = time_stamps(i+1);
%         a = a + 1;
%     end
% end
% 
% % Response markers
% a = 1;
% resp = zeros(1,128);
% for i = 1:nMarkers
%     if markers(i) == 8 && markers(i+1) == 9
%         resp(a) = time_stamps(i+1);
%         a = a + 1;
%     end
% end
% 
% % End Trial markers
% a = 1;
% endTrial = zeros(1,128);
% for i = 1:nMarkers-1
%     if markers(i) == 9 && markers(i+1) == 0
%         endTrial(a) = time_stamps(i+1);
%         a = a + 1;
%     end
% end


end
