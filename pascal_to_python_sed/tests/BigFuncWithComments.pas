function _SumRad(fi : real; cDate : TDate) : real;
var   dl, b1, b2 : double;
      FiRad, sd, hour1, hour2, shour1, shour2 : double;
      Iday : integer;
      cFluxRad : double;
      TotalFluxRad : double;
begin
   dl := _DayLength(fi, cDate);
   // Переводим широту в радианы
   FiRad := fi * pi / 180;
   // Вычисляем номер дня
   IDay := DayOfTheYear(cDate);
   // Годовой угол
   sd := 0.4102 * sin(0.0172 * (Iday - 80.25));
   // Константы суточного хода Солнца
   b1 := sin(FiRad)*sin(sd);
   b2 := cos(FiRad)*cos(sd);
   hour1 := 12 - dl/2;
   TotalFluxRad := 0.0;
   repeat
     hour2 := hour1 + 1;
     if (hour2 > 12 + dl/2)
       then hour2 := 12 + dl/2;
     shour1 := sinhour(hour1,b1,b2);
     shour2 := sinhour(hour2,b1,b2);
     cFluxRad := 0.5*(AQR(shour1) + AQR(shour2))*(hour2-hour1);
     TotalFluxRad := TotalFluxRad + cFluxRad;
     hour1 := hour2;
   until (hour2 >= 12 + dl/2);
   Result := TotalFluxRad;
end;
