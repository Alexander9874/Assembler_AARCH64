#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include <fcntl.h>
#include <errno.h>

double ** get_matrix(FILE * f_in, int size)
{
	double ** matrix = malloc(size * sizeof(double *));

	for(int i = 0; i < size; i++)
	{
		matrix[i] = malloc(size * sizeof(double));
		for(int j = 0; j < size; j++)
		{
			fscanf(f_in, "%lf", matrix[i] + j);
		}
	}
	return matrix;
}

void print_matrix(int size, double ** matrix)
{
	printf("\n");
	for(int i = 0; i < size; i++)
	{
		for(int j = 0; j < size; j++)
		{
			printf("%lf ", matrix[i][j]);
		}
		printf("\n");
	}
	printf("\n");
	return;
}

void delete_matrix(int size, double ** matrix)
{
	for(int i = 0; i < size; i++)
	{
		free(matrix[i]);
	}
	free(matrix);
	return;
}

double ** gauss(int size, double ** matrix)
{
	double tmp_1;
	double ** result = malloc(size * sizeof(double *));
	for(int i = 0; i < size; i++)
	{
		result[i] = calloc(size, sizeof(double));
		result[i][i] = 1.0;
	}
	for(int i = 0; i < size; i++)
	{
		if(matrix[i][i] == 0.0)
		{
			for(int j = i + 1; j < size; j++)
			{
				if(matrix[j][i] != 0.0)
				{
					for(int k = 0; k < size; k++)
					{
						matrix[i][k] += matrix[j][k];
						result[i][k] += result[j][k]; 
					}
					break;
				}
			}
			if(matrix[i][i] == 0.0)
			{
				delete_matrix(size, result);
				return NULL;
			}
		}
		tmp_1 = matrix[i][i]; 
		for(int j = 0; j < size; j++)
		{
			matrix[i][j] /= tmp_1;
			result[i][j] /= tmp_1;
		}
		for(int j = i + 1; j < size; j++)
		{
			tmp_1 = matrix[j][i];
			for(int k = 0; k < size; k++)
			{
				matrix[j][k] -= matrix[i][k] * tmp_1;
				result[j][k] -= result[i][k] * tmp_1;
			}
		}
	}
	for(int i = size - 1; i >= 0; i--)
	{
		for(int j = 0; j < i; j++)
		{
			tmp_1 = matrix[j][i];
			for(int k = 0; k < size; k++)
			{
				matrix[j][k] -= matrix[i][k] * tmp_1;
				result[j][k] -= result[i][k] * tmp_1;
			}
		}
	}
	return result;
}

//
//
//

int main(int argc, char * argv[])
{
	
	if(argc < 2)
	{
		fprintf(stderr, "Errore: No files entered!\n");
		return 1;
	}

	for(int file_num = 1; file_num < argc - 1; file_num++)
	{
		printf("file name : %s\n\n", argv[file_num]);
		FILE * f_in = fopen(argv[file_num], "r");
		if(!f_in)
		{
			fprintf(stderr, "File %s doesn't exists. Skip this file.\n\n", argv[file_num]);
			continue;
		}
		
		int size;
		fscanf(f_in, "%d", &size);
		printf("Matrix size is %d\n\n", size);
		double ** matrix = get_matrix(f_in, size);
		print_matrix(size, matrix);
		
		double ** result = gauss(size, matrix);
		if(result)
		{
			print_matrix(size, result);
			delete_matrix(size, result);
		}
		else
		{
			printf("det == 0\n\n");
		}

		delete_matrix(size, matrix);
		
		fclose(f_in);
	}
	return 0;
}
