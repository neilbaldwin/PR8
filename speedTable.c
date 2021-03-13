unsigned int speed, speed1, speed2;

int printSpeed (int pos)
{
	if (pos==0) {
		//printf("\n\t.BYTE %.2X",speed);
		printf("\n\t.BYTE ");
	}
	printf("$%.2X,$%.2X", speed1,speed2);
	if (pos!=2) printf(",");
	return 0;	
}

int main (int argc, const char * argv[])
{
	
	
	while (speed < 30)
	{
		speed1 = speed / 2;
		speed1 = speed1 * 1.0;
		speed2 = speed - speed1;
		printSpeed(0);
		speed1 = speed / 2;
		speed1 = speed1 * 1.25;
		speed2 = speed - speed1;
		printSpeed(1);
		speed1 = speed / 2;
		speed1 = speed1 * 1.50;
		speed2 = speed - speed1;
		printSpeed(1);
		speed1 = speed / 2;
		speed1 = speed1 * 1.75;
		speed2 = speed - speed1;
		printSpeed(2);
		
		speed+=1;
	}
	return 0;
}