
if (pode_sumir) 
{
	speed = .2
	image_alpha = lerp(image_alpha,0,.01)
	image_xscale = lerp(image_xscale,0,.05)
	image_yscale = lerp(image_yscale,0,.05)
}
else
{
	image_xscale = lerp(image_xscale,.5,.1)
	image_yscale = lerp(image_yscale,.5,.1)	
}

if (image_alpha <= .05) instance_destroy();


//TODO COMO ESSE NUMERO QUEBRA O SANGUE?????????? WTF TITAN
depth = -99999