int current_index=0;
int radius = 8;
int scale = screen.width-200;
int yc=110;
int rectX =120;
float e =0.0;

int totalPpl;
boolean Label = false;
int[][] mapping_score;
int[][] mapping_distance;
int mapping_min =65;
int mapping_max =2250;

int[][] dis;
int[] sorting ;


class Person {
  Person(String NAME) {
    this.NAME = NAME;
    this.ROLE = ROLE;
    mbti_type_16 = new String();
    mbti_data = new int[];
    mbti_type = new String[];
  }
  String NAME;
  String ROLE;
  String mbti_type_16;
  int[] mbti_data;
  String[] mbti_type;
};

Person[] persons;
  

void setup() {
  colorMode(RGB);
  smooth();
 
  

  String lines[] = loadStrings("mbtiData.csv");
  totalPpl = lines.length;
  size(screen.width, yc*(totalPpl+1)); 
  
  // initiate person
  persons = new Person[totalPpl];
  for (int i =0; i<totalPpl ; i++){
    persons[i] = new Person( " \" " +i+ " \" ");
  }
  
  //score record
  mapping_score = new int[totalPpl][4];
  mapping_distance = new int[totalPpl][totalPpl-1];
 
  // group
  dis = new int[totalPpl][totalPpl*(totalPpl-1)/2];
  sorting = new int[totalPpl*(totalPpl-1)/2];
  
    for (int person_index=0; person_index < totalPpl; person_index++) {      
      String[] list = split(lines[person_index], ',');
      

      persons[person_index].NAME = list[1];
      persons[person_index].ROLE = list[10];

   

      persons[person_index].mbti_type = {};
      persons[person_index].mbti_data = {};
      for (int a=2 ; a<6 ; a++) {        
          persons[person_index].mbti_type = append(persons[person_index].mbti_type, list[a]);
                //mbti type
        } 
      for (int b=6 ; b<10 ; b++) {
         persons[person_index].mbti_data = append(persons[person_index].mbti_data, list[b]);
                   //mbti value
        } 
  }

  mappingDots();
  calculate_dist();   //get mapping_min,max  
  
}

void draw() {
  background(50);
  
  textAlign(LEFT);
  noStroke();
  
  drawbg();

  draw_calculate_dist();  // draw
  
}


void draw_calculate_dist(){
  
  int[] dis_of_type  = new int[4];
  
 
  for (int m=0; m< totalPpl; m++)
  {     
       for(int n= 0 ; n< totalPpl ; n++)
       {
         //if (m != n){
           for (int i=0; i<4 ;i++)
           {
             dis_of_type[i] = abs(mapping_score[m][i] - mapping_score[n][i]);
           }      
           dis[m][n] = dis_of_type[0] + dis_of_type[1] + dis_of_type[2] + dis_of_type[3];

           drawDistanceDots(m, n, dis[m][n], m);
           
        // }
      }
  }
    
}

void calculate_dist(){
  
  int[] dis_of_type  = new int[4];
  
  int j=0;
 
  for (int m=0; m< totalPpl; m++)
  {     
       for(int n= m+1 ; n< totalPpl ; n++)
       {
         
         for (int i=0; i<4 ;i++)
         {
           dis_of_type[i] = abs(mapping_score[m][i] - mapping_score[n][i]);
         }      
         dis[m][n] = dis_of_type[0] + dis_of_type[1] + dis_of_type[2] + dis_of_type[3];
         //println("m="+m+":n="+n+":dis="+dis[m][n]);
         
         sorting[j]= ceil(dis[m][n]);
         j++;
      }
  }
      
  
  sorting = sort(sorting);
}



void drawDistanceDots(int m, int n, int dis ,int y_value){
    mapping_min = sorting[0];
    mapping_max = sorting[totalPpl*(totalPpl-1)/2-1];
 
      if (window.devicePixelRatio <=1)  
        {int distance = (int)map(dis/2,mapping_min/2,mapping_max/2,0,scale-200);  }
      else
        {int distance = (int)map(dis,mapping_min,mapping_max,0,scale);  }

        int fillincolor = setcolor(persons[n].mbti_type_16);
        fill(fillincolor);
        textSize(10);
        ellipse(distance+rectX, yc*(y_value+1)+radius , radius, radius);
        
        if(Label){

          textAlign(LEFT);  
          pushMatrix(); 
          translate(distance+rectX, yc*(y_value+1)-n);
          rotate(-PI/3.0);
          text(persons[n].NAME, 0, 0);
          popMatrix();
        }
        
}


void mappingDots(){
  for (int m=0; m<totalPpl; m++)
  {
      noFill();
      noStroke();
      
      persons[m].mbti_type_16 = persons[m].mbti_type[0]+persons[m].mbti_type[1]+persons[m].mbti_type[2]+persons[m].mbti_type[3];
      
      
      for (int j=2 ; j<6 ; j++) { 
       
        String item = persons[m].mbti_type[j-2];
        //text(item, j*30+100, (m+1)*20);
        
        if (j==2) {drawDots(item, m, "I", 0);}        //draw I/E
        else if (j==3) {drawDots(item, m, "N", 1);}   //draw N/S
        else if (j==4) {drawDots(item, m, "F", 2);}   //draw F/T
        else {drawDots(item, m, "P", 3);}             //draw P/J
        
      } 
      
  }
}
void drawDots(String item, int m, String b, int index){
     int x;
        if (item.equals(b)){
          x = 100 - (int)persons[m].mbti_data[index]; 
        }
        else { 
          x = 100 + (int)persons[m].mbti_data[index];
        }
        mapping_score[m][index] = map(x,0,200,0,scale);  
    
}




int setcolor(String mbti_type){
  switch(mbti_type){
    case "INTP":
      return #d37eff;
    case "INFP":
      return #9c7eff;
    case "INTJ":
      return #7e96ff;
    case "INFJ":
      return #57a0ea;
    case "ISTJ":
      return #64ced2;
    case "ENTP":
      return #ea8857;
    case "ENFP":
      return #eabf57;
    case "ENFJ":
      return #e5ea57;
    case "ESFP":
      return #aeea57;
    case "ESFJ":
      return #73ea57;
  }
  return 0;
}

void mouseClicked(){
  if (Label){
    Label = false; 
  }
  else {Label = true;}
}



void drawbg(){
  
  noFill();
  noStroke();
  
  // diagram
  for (int i=0; i<totalPpl ; i++)
  {
    fill(200);
    textAlign(LEFT);
    textSize(12);
    text(persons[i].NAME, 60, yc*(i+1)+radius*2+5);
    fill(100);
    rect(rectX, yc*(i+1)+radius*2 , scale, 5);
  }
  
}
