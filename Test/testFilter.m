function frame = testFilter(frame)
   dat = frame.r;
   indx = dat(2,:) > 340;
   frame.objects = frame.objects(indx);
end
