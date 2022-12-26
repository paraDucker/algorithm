function o=dominates(x,y)
    
    o=all(x<=y) && any(x<y);

end