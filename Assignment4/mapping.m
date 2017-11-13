size_m=size(mapping);
size_f=size(features);
result=zeros(size_f(1),1);
for f=1:size_f(1)
    for m=1:size_m(1)
        if(features(f,1)==mapping(m,3))
            result(f,1)=mapping(m,1);
        end
    end
end