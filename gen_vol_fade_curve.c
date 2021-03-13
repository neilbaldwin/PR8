/* Generates volume fade curves. See below for things you can edit. */

#include <stdio.h>
#include <math.h>

/* Copyright (C) 2010 Shay Green <gblargg@gmail.com>. Permission to use,
copy, modify, and/or distribute this software for any purpose with or without
fee is hereby granted, provided that the above copyright notice and this
permission notice appear in all copies. PROVIDED "AS IS" WITHOUT WARRANTY. */

int const in_range  = 16; /* size of table */
int const out_range = 16; /* values in table are from 0 to out_range-1 */

static const double pi = 3.14159265358979323846;

/*
// Verifies that scaling is correct
static double lin_curve( double in )
{
	return in;
}

static double cos_curve( double in )
{
	double y = cos( pi * in );
	return y * -0.5 + 0.5;
}
*/

static double exp_curve( double in, double adjust )
{
	//double adjust = 0.6; // how steep; 1.0 = linear
	double offset = 0.0;  //adjust to get rid of learing zeroes
	return pow( (1 - offset) * in + offset, adjust );
}

static double (*func)( double, double ) = exp_curve; /* selects curve function */

static void calculate( int graph, double adjust )
{
	int i;
	for ( i = 0; i < in_range; i++ )
	{
		/* Funny adjustments ensure that linear ramp is spread evenly along output */
		double in = 1.0 / (in_range - 0.99999) * i; /* 0 to almost 1.0 */
		double fout = func( in, adjust ) * (out_range - 0.00001); /* 0 to almost out_range */
		
		int out = (int) floor( fout );
		
		/* Shouldn't go outside range, so clamping won't affect things normally */
		if ( out < 0 )
			out = 0;
		
		if ( out >= out_range )
			out = out_range - 1;
		
		if ( graph )
		{
			/* Graph on its side, by varying string length */
			printf( ";%3d %*s\n", out, out * 70 / out_range, "*" );
		}
		else
		{
			/* Output as .byte directives for assembler */
			if ( i % 16 == 0 )
				printf( "\t.BYTE " );
			else
				printf( "," );
			
			printf( "%3d", out );
			
			if ( i % 16 == 15 )
				printf( "\n" );
		}
	}
}

int main( void )
{
	/* Put assembler data first, then graph */
	calculate( 0, 8.0 );
	calculate( 0, 7.0);
	calculate( 0, 6.0 );
	calculate( 0, 5.0 );
	calculate( 0, 4.0 );
	calculate( 0, 3.0 );
	calculate( 0, 2.0 );
	calculate( 0, 1.5 );
	calculate( 0, 1.0 ); // linear
	calculate( 0, 0.9 );
	calculate( 0, 0.8 );
	calculate( 0, 0.7 );
	calculate( 0, 0.6 );
	calculate( 0, 0.5 );
	calculate( 0, 0.4 );
	calculate( 0, 0.3 );
	printf( "\n\n" );
	//calculate( 1, 0.5 );
	
	return 0;
}
