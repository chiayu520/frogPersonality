int current_index=0;
int radius = 8;
int scale = screen.width-200;
int yc=110;
int n = 55;
int totalPpl;
boolean Label = false;
int[][] mapping_score;
String[][] tabledatas;

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
  size(screen.width, 640); 


  String lines[] = loadStrings("mbtiData.csv");
  
  totalPpl = lines.length;



  
  // initiate person
  persons = new Person[totalPpl];
  for (int i=0; i<totalPpl ; i++){
    persons[i] = new Person( " \" " +i+ " \" ");
  }
  
  //score record
  mapping_score = new int[totalPpl][4];
  
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
      // println(persons[person_index].NAME);
      // println(persons[person_index].ROLE);
      // println(persons[person_index].mbti_type);
      // println(persons[person_index].mbti_data);
  }
}

void draw() {
  background(50);
  
  textAlign(LEFT);
  noStroke();
  
  drawbg();
  mappingDots();
  linkage();
   
}

void mappingDots(){
  for (int m=0; m<totalPpl; m++)
  {
      noFill();
      noStroke();
      
      persons[m].mbti_type_16 = persons[m].mbti_type[0]+persons[m].mbti_type[1]+persons[m].mbti_type[2]+persons[m].mbti_type[3];
      
      
      for (int j=2 ; j<6 ; j++) { 
       
        String item = persons[m].mbti_type[j-2];

        if (j==2) {drawDots(item, m, "I", 0, yc);}        //draw I/E
        else if (j==3) {drawDots(item, m, "N", 1, yc*2);}   //draw N/S
        else if (j==4) {drawDots(item, m, "F", 2, yc*3);}   //draw F/T
        else {drawDots(item, m, "P", 3, yc*4);}             //draw P/J
        
      } 
  }
}

void drawDots(String item, int m, String b, int index, int y){
     int x;
        if (item.equals(b)){
          x = 100 - (int)persons[m].mbti_data[index]; 
        }
        else { 
          x = 100 + (int)persons[m].mbti_data[index];
        }
        mapping_score[m][index] = map(x,0,200,0,scale);  
        
    
        int fillincolor = setcolor(persons[m].mbti_type_16);
        fill(fillincolor);
        textSize(10);
        ellipse(mapping_score[m][index]+50, y, radius, radius);
        
        if(Label){

           textAlign(LEFT);  
          pushMatrix(); 
          translate(mapping_score[m][index]+50+m+5, y-radius-m);
          rotate(-PI/3.0);
          text(persons[m].NAME, 0, 0);
          popMatrix();
        }
        
}




void linkage(){    
  String s = hover();
  String b = "0";
  if (s.equals(b)){
  }
  else  {
    request(s);
  }
}

void request(String s){      
    for (int m=0 ; m<totalPpl ; m++ ){
          if(persons[m].mbti_type_16.equals(s)){   
            drawLink(m);
          }
          if(persons[m].ROLE.equals(s)){   
            drawLink(m);
          }
    }
}

void drawLink(int m){
       int fillincolor = setcolor(persons[m].mbti_type_16);
       stroke(fillincolor, 90);
       strokeWeight(3);
       line(mapping_score[m][0]+50, yc, mapping_score[m][1]+50, yc*2);
       line(mapping_score[m][1]+50, yc*2, mapping_score[m][2]+50, yc*3);
       line(mapping_score[m][2]+50, yc*3, mapping_score[m][3]+50, yc*4);
       
        // show the name
        fill(fillincolor);
         textAlign(LEFT);  
          pushMatrix(); 
          translate(mapping_score[m][0]+50+m+5, yc-radius-m);
          rotate(-PI/3.0);
          text(persons[m].NAME, 0, 0);
          popMatrix();
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
    case "ENTJ":
      return #e5ea57;
    case "ENFJ":
      return #acb210;
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
  textSize(16);
  //index
  int c;
  c = setcolor("INTP");
  fill(c);
  text("INTP", n, n*10);
  c = setcolor("INFP");
  fill(c);
  text("INFP", n*2, n*10);
  c = setcolor("INTJ");
  fill(c);
  text("INTJ", n*3, n*10);
  c = setcolor("INFJ");
  fill(c); 
  text("INFJ", n*4, n*10);
  c = setcolor("ISTJ");
  fill(c);
  text("ISTJ", n*5, n*10);  
  c = setcolor("ENTP");
  fill(c);
  text("ENTP", n*6, n*10);
  c = setcolor("ENFP");
  fill(c);
  text("ENFP", n*7, n*10);
  c = setcolor("ENTJ");
  fill(c);
  text("ENTJ", n*8, n*10);
  c = setcolor("ENFJ");
  fill(c);
  text("ENFJ", n*9, n*10);
  c = setcolor("ESFP");
  fill(c);
  text("ESFP", n*10, n*10);
  c = setcolor("ESFJ");
  fill(c);
  text("ESFJ", n*11, n*10);


  // role
  fill(200);
  int yn= n*11;
  text("FIN", n*1, yn);
  text("MK", n*2, yn);
  text("BD", n*3, yn);
  text("PM", n*4, yn);
  text("VD", n*5, yn);
  text("IxD", n*6, yn);
  text("ST", n*7, yn);
  text("DR", n*8, yn);
  text("DT", n*9, yn);
  text("HR", n*10, yn);
  text("ELSE", n*11, yn);

  // diagram
  fill(170);
  text("I", 40-8, yc+8+radius);
  text("N", 40-8, yc*2+8+radius);
  text("F", 40-8, yc*3+8+radius);
  text("P", 40-8, yc*4+8+radius);
  rect(50, yc+radius, scale/2, 5);
  rect(50, yc*2+radius, scale/2, 5);
  rect(50, yc*3+radius, scale/2, 5);
  rect(50, yc*4+radius, scale/2, 5);
  fill(220);
  text("E", scale+60, yc+8+radius);
  text("S", scale+60, yc*2+8+radius);
  text("T", scale+60, yc*3+8+radius);
  text("J", scale+60, yc*4+8+radius);
  rect(scale/2+50, yc+radius, scale/2, 5);
  rect(scale/2+50, yc*2+radius, scale/2, 5);
  rect(scale/2+50, yc*3+radius, scale/2, 5);
  rect(scale/2+50, yc*4+radius, scale/2, 5);
}

String hover(){
  if (mouseY < n*10+10 && mouseY > n*10-10){
     if ( mouseX > n-5 && mouseX < n*2-5){
       return "INTP";
     }
     if ( mouseX > n*2-5 && mouseX < n*3-5){
       return "INFP";
     }
     if ( mouseX > n*3-5 && mouseX < n*4-5){
       return "INTJ";
     }
     if ( mouseX > n*4-5 && mouseX < n*5-5){
       return "INFJ";
     }
     if ( mouseX > n*5-5 && mouseX < n*6-5){
       return "ISTJ";
     }
     if ( mouseX > n*6-5 && mouseX < n*7-5){
       return "ENTP";
     }
     if ( mouseX > n*7-5 && mouseX < n*8-5){
       return "ENFP";
     }
     if ( mouseX > n*8-5 && mouseX < n*9-5){
       return "ENTJ";
     }
     if ( mouseX > n*9-5 && mouseX < n*10-5){
       return "ENFJ";
     }
     if ( mouseX > n*10-5 && mouseX < n*11-5){
       return "ESFP";
     }
     if ( mouseX > n*11-5 && mouseX < n*12-5){
       return "ESFJ";
     }
     return "0";
  }


    //role
  if (mouseY < n*11+10 && mouseY > n*11-10){
     if ( mouseX > n*-5 && mouseX < n*2-5){
       return "FIN";
     }
     if ( mouseX > n*2-5 && mouseX < n*3-5){
       return "MK";
     }
     if ( mouseX > n*3-5 && mouseX < n*4-5){
       return "BD";
     }
     if ( mouseX > n*4-5 && mouseX < n*5-5){
       return "PM";
     }
     if ( mouseX > n*5-5 && mouseX < n*6-5){
       return "VD";
     }
     if ( mouseX > n*6-5 && mouseX < n*7-5){
       return "IxD";
     }
     if ( mouseX > n*7-5 && mouseX < n*8-5){
       return "ST";
     }
     if ( mouseX > n*8-5 && mouseX < n*9-5){
       return "DR";
     }
     if ( mouseX > n*9-5 && mouseX < n*10-5){
       return "DT";
     }
     if ( mouseX > n*10-5 && mouseX < n*11-5){
       return "HR";
     }
     if ( mouseX > n*11-5 && mouseX < n*12-5){
       return "ELSE";
     }
     return "0";
  }

  return "0";
  

}