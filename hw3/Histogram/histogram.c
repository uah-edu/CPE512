/**************************************************************/
/* Histogram construction Program -- Serial version           */
/* September 2023 -- B. Earl Wells -- University of Alabama   */
/* (C   Program)                     in Huntsville            */
/**************************************************************/
/*
The program represents the sequential version of a histogram 
program, that is used used often in the CPE 412/512 text. 
The program creates a histogram of an array of numbers which 
are generated peudo randomly in a manner that has a normal 
distribution with a mean MEAN and standard deviation given by 
the symbolic constants expressed below:
*/

#define MEAN  50.0
#define STDEV 20.0

/*
Compilation

   GNU Compiler
   gcc histogram.c -o histogram -lm

To execute:
   
   GNU compiler
   histogram

*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/*
Function used by get_parameters routine to prompt the user to 
interactively enter the next integer parameter and to return
it to the calling routine
*/
int enter_next_int_param(char * prompt) {
   int num;
   char str[81];
   printf("%s",prompt);
   fflush(stdout);
   while (fgets (str,80,stdin)==NULL)
      printf("Invalid Input\n");
   num = atoi(str);
   return num;
}

/*
Function used by get_parameters routine to prompt the user to 
interactively enter the next double parameter and to return
it to the calling routine
*/
double enter_next_double_param(char * prompt) {
   double num;
   char str[81];
   printf("%s",prompt);
   fflush(stdout);
   while (fgets (str,80,stdin)==NULL)
      printf("Invalid Input\n");
   num = atof(str);
   return num;
}

/*
Function used by get_parameters routine to prompt the user to 
interactively enter the next char parameter and to return
it to the calling routine
*/
char enter_next_char_param(char * prompt) {
   char num;
   char str[81];
   printf("%s",prompt);
   fflush(stdout);
   while (fgets (str,80,stdin)==NULL)
      printf("Invalid Input\n");
   num = str[0];
   return num;
}

/*
Routine to retrieve the run time parameters which include
1) the number of numbers in the number list,
2) number of equally spaced bins to be used by the histogram,
3) maximum value in bin range, 4) minimum value in bin range.
If there is a 5th run time parameter then outputing of the numbers 
array that was generated is suppressed 
If no parameters are supplied on the command line, then the program
interactively prompts the user for the information.
*/
void get_parameters(int *list_size,int *num_bins,double *max_bin_val, 
   double *min_bin_val,int *num_list_out, int argc,char *argv[]) {

   if(argc==1) {
      // One Command Line Argument Case:
      // case where user did not enter number of numbers on command line
      *list_size=enter_next_int_param("Enter number of numbers in list:");
      *num_bins=enter_next_int_param("Enter number of bins in histogram:");
      *max_bin_val=enter_next_double_param("Enter Upper Range of histogram:");
      *min_bin_val=enter_next_double_param("Enter Lower Range of histogram:");
      char print_out=enter_next_char_param("Suppress numbers array printing (y or n):");
      if (print_out=='y' || print_out=='Y') *num_list_out=0; 
   }
   else if (argc==5 || argc==6) {
      // Two Command Line Argument case:
      // user supplied the number of numbers on the command line.
      *list_size = atoi(argv[1]); // get list_size from command line
      *num_bins = atoi(argv[2]);  // get num_bins from command line
      *max_bin_val = atoi(argv[3]);  // get max_bin_val from command line
      *min_bin_val = atoi(argv[4]);  // get min_bin_val from command line
      if (argc==6) *num_list_out=0; // suppress output of numbers array
   }
   else {
      printf("Usage: histogram [list");
      printf(" size num_bins max_bin_val min_bin_val]\n");
      exit(1); // Exit Program 
   }
}

/*
Routine that fills a 1-D array with Random Data with values
based on a normal distibution that has a mean of MEAN and a
standard deviation of STDEV
*/
#include <stdlib.h>
void srand48(long int seedval);
double drand48(void);
void create_list(double *numbers,int list_size) {
   double epsilon = 2.22044604925031308084726333618164062e-16;
   double two_pi = 2.0 * 3.141592653589793115997963468544e+00;

   srand48((long int) 123446);
   // using Box–Muller transform to generate normalally distributed
   // random numbers from uniformly distributed ones
   // ref: https://en.wikipedia.org/wiki/Box-Muller_transform 
   double u1,u2,z0,num;
   for(int i=0;i<list_size;i++) {
      do {
         u1 = drand48();
         u2 = drand48();
      } while (u1 <= epsilon);
      z0 = sqrt(-2.0 * log(u1)) * cos(two_pi * u2);
      num = z0*STDEV+MEAN;

      numbers[i]=num;
   }
}

// Routine that outputs the numbers matrix to the screen 
void print_matrix(double *numbers,int list_size)
{
   for(int i=0;i<list_size;i++) {
      printf("%f\n",numbers[i]);
   }
}


// MAIN ROUTINE: parallel histogram calculation
int main(int argc, char *argv[]) {

   //get run time parameters from the user
   // list_size == number of numbers to generate on root node
   // num_bins  == number of equally-spaced bins for the histogram
   // value range (max_val,min_val) that is being recorded in the histogram
   int list_size, num_bins;
   double max_val, min_val;
   int print_flg=1; // default is to print numbers out to screen

   get_parameters(&list_size,&num_bins,&max_val,&min_val,&print_flg,
      argc,argv);
   // compute the range associated with each bin
   const double bin_range = (max_val-min_val)/num_bins;

   double *numbers;
   int *histogram;

   // dynamically allocate from heap the histogram array
   histogram = (int *) malloc (num_bins*sizeof(int));
   // Check for unsucessful memory allocation
   if (histogram == NULL) {  
      printf("Memory allocation Error for ");
      printf("histogram array\n");
      fflush(stdout);
      exit(1);
   }

   // dynamically allocate from heap the histogram array
   numbers = (double *) malloc (list_size*sizeof(double));
   // Check for unsucessful memory allocation
   if (numbers == NULL) {  
      printf("Memory allocation Error for ");
      printf("numbers array\n");
      fflush(stdout);
      exit(1);
   }

   // initialize numbers array with random data
   create_list(numbers,list_size);

   // print the array if printing is enabled
   if (print_flg) { 
      printf("numbers matrix =\n"); 
      print_matrix(numbers,list_size);
      printf("\n");
   }

 
   // create histogram of the set of numbers

   // clear out histogram array
   for (int i=0;i<num_bins;i++) histogram[i]=0.0;
 
   // compute the local histogram for the local set of numbers
   for (int i=0;i<list_size;i++) {
      double num;
      num = numbers[i];
      if (num>=min_val && num < max_val) {
         num -= min_val;
         histogram[(int) (num/bin_range)]++;
      }
   }

   // output final histogram 
   printf("Histogram Information\n");
   for (int i=0;i<num_bins;i++) {
      printf("%f  %d\n",min_val+bin_range/2+bin_range*i, 
      histogram[i]);
   }
   fflush(stdout);

   // reclaim dynamiclly allocated memory
   free(histogram);
   free(numbers);

}

