function AP(arg1, arg2 : double ; arg3, arg4, arg5 : double) : double;
var a, al : double;
begin
   if (cLAI>1e-8) then
     sleep(0);
   a := -RConst1*cLAI/shour;
   if a<-9.0 then a:=-9.0;
   al := RConst2 * (exp(a*RConst3)-exp(a));
   result := (dir_diff*exp(a)+exp(-cLAI))/(dir_diff+1) + al;
end;
