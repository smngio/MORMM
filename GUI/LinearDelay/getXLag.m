function out = getXLag(obj,int)

delayT = obj.delayT;

a_column = {delayT.a};

b_column = {delayT.b};

delay_column = [delayT.delay];

ind_a = ~cellfun('isempty',cellfun(@(y)find(y~=0),a_column,'UniformOutput',false));

ind_b = ~cellfun('isempty',cellfun(@(y)find(y~=0),b_column,'UniformOutput',false));

xLag = delay_column(ind_a);

xLag_0 = [0 xLag];

wLag = delay_column(ind_b);

if(isempty(wLag))
    wLag=0;
end

if(length(wLag)==1)
    
    wLag_0 = [0 wLag];
    
    if(wLag==0)
        wLag=[];
    end
    
else
    
    wLag_0 = wLag;
    
end

if(int == 0)
    
    out = [xLag_0,wLag_0];
    
else
    
    out = [xLag,wLag];
    
end
    
        