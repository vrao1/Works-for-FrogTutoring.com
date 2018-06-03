
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include "reduce_game.h"


void reduce(game_t g) {

	bool **reduction_flags;
	bool furtherElimination = true;

	int initial_n = g->n;
	int initial_m = g->m;

	while(furtherElimination == true){
		// Find the dominated strategy for player 1 by keeping columns constant at a time
		
		int n = g->n; // Rows
		int m = g->m; // Columns
		reduction_flags = (bool **) malloc(sizeof(bool *)*n); 
		int k = 0;
		
		while(k < n){
			reduction_flags[k] = (bool *) calloc(m, sizeof(bool)); // Default to False
  			k++;
		}
/*
  		for(int i = 0;i < n;i++){
			for(int j=0;j < m;j++){
				printf("(%f, %f) ", g->player1[i][j], g->player2[i][j]);
			}
			printf("\n");
		}
*/
		for(int j = 0;j < m;j++){

			// Following array is to store column wise values with corresponding index
			double column_wise_strategy[n][2];

			for(int i=0;i < n;i++){
				column_wise_strategy[i][0] = g->player1[i][j];
				column_wise_strategy[i][1] = (double)i;
			}

			int allEqual = 1;
			// Ordering rank wise in ascedending order
			for(int a=0;a<n-1;a++)
				for(int b=a+1;b<n;b++)
					if(column_wise_strategy[a][0] > column_wise_strategy[b][0]){
						double temp = column_wise_strategy[a][0];
						double temp_index = column_wise_strategy[a][1];
						column_wise_strategy[a][0] = column_wise_strategy[b][0];
						column_wise_strategy[a][1] = column_wise_strategy[b][1];
						column_wise_strategy[b][0] = temp;
						column_wise_strategy[b][1] = temp_index;
					}else if(column_wise_strategy[a][0] == column_wise_strategy[b][0]){
						allEqual++;
					}

			if(allEqual < n){
				for(int i=0;i < n-1;i++){
					reduction_flags[(int)column_wise_strategy[i][1]][j] = true;
				}
			}
		}

		/*printf("After Player 1 strategy fixed\n");
  		for(int i = 0;i < n;i++){
			for(int j=0;j < m;j++){
				printf("(%d) ", reduction_flags[i][j]);
			}
			printf("\n");
		}*/

		// Find the dominated strategy for player 2 by keeping rows constant at a time
  		for(int i = 0;i < n;i++){

			// Following array is to store row wise values with corresponding index
			double row_wise_strategy[m][2];

			for(int j=0;j < m;j++){
				row_wise_strategy[j][0] = g->player2[i][j];
				row_wise_strategy[j][1] = (double)j;
			}

			int allEqual = 1;
			// Ordering rank wise in ascedending order
			for(int a=0;a < m-1;a++){
				for(int b=a+1;b < m;b++){
					if(row_wise_strategy[a][0] > row_wise_strategy[b][0]){
						double temp = row_wise_strategy[a][0];
						double temp_index = row_wise_strategy[a][1];
						row_wise_strategy[a][0] = row_wise_strategy[b][0];
						row_wise_strategy[a][1] = row_wise_strategy[b][1];
						row_wise_strategy[b][0] = temp;
						row_wise_strategy[b][1] = temp_index;
					}else if(row_wise_strategy[a][0] == row_wise_strategy[b][0]){
						allEqual++;
					}
				}
/*
				printf("For Row Number = %d || iteration Number a = %d\n", i,a);
				for(int j=0;j < m;j++){
					printf("[%f , %f] ", row_wise_strategy[j][0],row_wise_strategy[j][1]);
				}
				printf("\n");*/
			}
			if(allEqual < m){
				for(int j=0;j < m-1;j++){
				//	if(i == 2)
				//	printf("index on column[j = %d] = %d ", j,(int)row_wise_strategy[j][1]);
					reduction_flags[i][(int)row_wise_strategy[j][1]] = true;
				}
			}
		}
/*
		printf("After Player 2 strategy fixed\n");
  		for(int i = 0;i < n;i++){
			for(int j=0;j < m;j++){
				printf("(%d) ", reduction_flags[i][j]);
			}
			printf("\n");
		}
*/

	// m is number of columns
	// n is number of rows

	furtherElimination = false;

	int count = 0;
	bool flag = true;
	bool initial_status;
	bool isNashEquilibrium = true;

	//printf("Reduction Flags before removing rows or columns\n\n");

	for(int i=0;i<n;i++){
		for(int j=0;j<m;j++){
			if(flag){
				initial_status = reduction_flags[i][j]; 
				flag = false;
				continue;
			}
	//		printf("Before XOR ---- initial_status = %d f[%d][%d] = %d  ,",initial_status, i,j,reduction_flags[i][j]);
				
			if(initial_status != reduction_flags[i][j]){
				isNashEquilibrium = false;
				i = n;
				break;
			} 
	//		printf("After XOR ----- initial_status = %d f[%d][%d] = %d  ,",initial_status, i,j,reduction_flags[i][j]);
			
		}
	//	printf("\n");
	}

	// This is case of Nash Equilibrium where all have either FALSE or TRUE , so there is a tie
	if(isNashEquilibrium == true && (n == initial_n && initial_m == m)){
//printf("OMG\n");
		furtherElimination = false;
		break;
	}

	int whichRowIsAboutToDelete = 0;
	// Remove Row if it is dominated by other row
  	for(int i = 0;i < n;i++){
		bool initial_status = true;
		for(int j = 0;j < m;j++){
			initial_status = initial_status & reduction_flags[i][j]; 
		}

		//printf("While Removing Row ---------- For row = %d , initial_status = %d\n", i, initial_status);

		if(initial_status == true){
		//	printf("Removing Row Game\n");
			remove_row_game(g, whichRowIsAboutToDelete);
			furtherElimination = true;
			n = g->n;
		}else{
			whichRowIsAboutToDelete++;
		}
	}

	// Remove Column if it is dominated by other column
	count = 0;

	// m is number of columns
	// n is number of rows
	int whichColumnIsAboutToDelete = 0;
  	for(int j = 0;j < m;j++){
		bool initial_status = true;
		for(int i = 0;i < n;i++){
			initial_status = initial_status & reduction_flags[i][j]; 
		}

		if(initial_status == true){
		//	printf("Removing column Game column j = %d\n", j);
			remove_col_game(g, whichColumnIsAboutToDelete);
			furtherElimination = true;
			m = g->m;
		//	printf("New m = %d\n", m);
			
		//	print_game(g);
		//	printf("----\n");
		}else{
			whichColumnIsAboutToDelete++;
		}
	}

	k = 0;
	while(k < n){
		free(reduction_flags[k]);
		reduction_flags[k] = NULL;
  		k++;
	}
	free(reduction_flags);
	}// while ends

	print_game(g);
}
