function [ start ] = extractbyPC(pcdata,emptyspace,trials)

start = zeros(trials,1);

a = 1;
b = 1;
for i = 1:length(pcdata)-emptyspace
    poi = a + emptyspace;
    temp = pcdata(a:a+emptyspace);
    if sum(temp) == 0 && pcdata(poi+1) > 0
        start(b) = poi;
        b = b + 1;
    end
    a = a + 1;
end

end

