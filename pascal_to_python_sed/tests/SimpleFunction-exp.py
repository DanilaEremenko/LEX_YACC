def AP(arg1, arg2 , arg3, arg4, arg5 ):
	a = al = 0.0
	
	if (cLAI>1e-8):
		sleep(0)
	a = -RConst1*cLAI/shour
	if a<-9.0: a=-9.0
	al = RConst2 * (exp(a*RConst3)-exp(a))
	result = (dir_diff*exp(a)+exp(-cLAI))/(dir_diff+1) + al
	
