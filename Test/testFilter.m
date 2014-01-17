function dd = testFilter(dd)
   dat = dd.toCoordinates();
   indx = dat(2,:) > 340;
   dd.objects = dd.objects(indx);
end
