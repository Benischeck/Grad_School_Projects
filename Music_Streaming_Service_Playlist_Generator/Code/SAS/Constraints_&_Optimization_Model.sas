proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx
	Out = average;
	sheet = 'avg_word';
	getnames=yes;
	run;
	
	
proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx
	Out = above_avg;
	sheet = 'above_average';
	getnames=yes;
	run;
proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx replace
	Out = preference;
	sheet = 'preference';
	getnames=yes;
	run;
proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx replace
	Out = Score_by_art;
	sheet = 'sheet2';
	getnames=yes;
	run;

proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx replace
	Out = general_like;
	sheet = 'likerate';
	getnames=yes;
	run;

proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx replace
	Out = score;
	sheet = 'score_1';
	getnames=yes;
	run;

proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx replace
	Out = avg_score;
	sheet = 'avg_score_by_group';
	getnames=yes;
	run;

proc import datafile = "E:\OPR\project\model.xlsx"
	DBMS = xlsx replace
	Out = above_20;
	sheet = 'above_20';
	getnames=yes;
	run;


/*proc standard data=Score_by_art out=Score_by_art_nm replace print; 
run; 

proc export data=score_by_art_nm
   outfile='E:\OPR\project\scorebyart.xlsx'
   dbms=xlsx; 
 run;*/

Proc optmodel;
set AGE;    *AGE groups from 1-7;
set GENDER; * Gender groups 1 and 2, 1 means male and 2 means female;
set ARTIST; *Represents 1-50 artists;
set <string> WORD; * Represents 10 word categories;
AGE={1..7};
GENDER= {1..2};
ARTIST={1..50};
WORD={'Timeless','Talented','Emotional','Ambient','Catchy','Teenage','Pop_Top_40','Chang','Classic_Rock', 'Lame'};

set <num, num, num> PREFER; 
*PREFER[age,gender,rank] to represent the ranked preference for age/gender;

set <num, num, str> LIKE;   
*LIKE[age,gender,word] to represent the preference rate each age/gender group assigned to word category;
 
set <num,num,num> SCORE;
*SCORE[age,gender,artist] to represent scores each age/gender group assigned to each artists;

set <num,num> AGEGENDER;
*AGEGENDER[age,gender] to represent age and gender group;

number aa=1; 
*the user's age information, assigned to different age group from 1 to 7;

number gg=1; 
*the user's genger information, 1 means male, 2 means female;

number average{WORD};
*the general average comparative preference rate for each word categories;

number above{ARTIST,WORD};
*the artists who have higher comparative preference rate compared to the average preference rate;

number above_20{ARTIST,WORD};
*above_20[i,S]=1 means the artists i have a more than 1.2 times the average preference rate for word category S;
*above_20[i,S]=0 means the artists i's S category preference rate is less than 1.2 times the average preference rate of this category; 

string word_p{PREFER};
*word_p[i,j,r]means the r_th preferred word categories for age group i and gender group j;

num likerate{LIKE};
*likerate[i,j,w]means the comparative preference rate for the w category for age i and gender j;

num score_s{SCORE};
*score_s[i,j,k]means the score age i and gender j assigned to k artist;

num avg_score{AGEGENDER};
*avg_score[i,j] represent the average score that age i and gender j assigned to 50 artists;

var X{AGE, GENDER, ARTIST} binary;
/* X[i,j,k]=1 indicates that users in the age group i and gender group j  should choose artists k into their playlist.
   X[i,j,k]=0 indicates not choose.*/

read data work.average into WORD=[words] average;
read data work.above_avg into ARTIST=[art]{w in WORD}< above[art,w] = col(w)>;
read data work.above_20 into ARTIST=[art]{w in WORD}<above_20[art,w]=col(w)>;
read data work.preference into PREFER=[age_p gender_p rank_p]word_p;
read data work.general_like into LIKE=[art_l gender_l word_l]likerate;
read data work.score into SCORE=[age_s gender_s artist_s]score_s;
read data work.avg_score into AGEGENDER=[age_a gender_a]avg_score;

minimize  least_like=sum {i in ARTIST} likerate[i,gg,word_p[aa,gg,10]] * X[aa,gg,i];
* minimize the total comparative preference rate for the least-like category of the particular age and gender group;

con c1:sum{i in ARTIST} X[aa,gg,i]=8;
* the total artists in the playlist is 8;

con threelike {r in 1..3}: sum{i in ARTIST} X[aa,gg,i]*likerate[i,gg,word_p[aa,gg,r]]>=average[word_p[aa,gg,r]]*8;
* for three-most like word categories, the average comparative preference rate should be at least the average top 5 preference rate;

con second_hate : sum{i in ARTIST} X[aa,gg,i]*likerate[i,gg,word_p[aa,gg,9]]<= average[word_p[aa,gg,9]]*8;
* for the second-hate like word categories, the average comparative preference rate should not excess the average top 5 preference rate;

con middle {r in 4..8}: sum{i in ARTIST} X[aa,gg,i]*above[i,word_p[aa,gg,r]]>=1;
* for each of the moderate word categories, we should at least choose one artist whose word category is higher than average rate;

con high_score {r in 1..10}: sum{i in ARTIST} X[aa,gg,i]*above_20[i,word_p[aa,gg,r]]<=5; 
* for the 1.2 higher than preference rate, we should not include more than 5 artists to ensure diversity;

con score_art: sum{i in ARTIST}X[aa,gg,i]*score_s[aa,gg,i]>=avg_score[aa,gg]*8;
* the average score in our playlist should be at least the average score of the age/gender group;

solve;
print X.sol;
quit;
