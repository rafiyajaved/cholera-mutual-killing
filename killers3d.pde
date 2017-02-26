import java.util.Iterator;
float dt=.1;
float cell_radius=10;
int num_cells=0;
float eta=.5;
int max_num_cells=(int)((1000/19)*(1000/19)*(1000/18));
Biofilm bugs= new Biofilm();
float k=1;
float growth_rate=.35;
float kill_thresh=1;
float grid_width=30;
float grid_height=30;
float grid_depth=30;
Grid grid=new Grid(grid_height,grid_width,grid_depth);
int growing=1;
int tick=1;


  
  void setup(){
    //directionalLight(200,200,200,0,0,1);
    size(700,700,P3D);
    lights();
    //size(900,900);
    background(0);
    init();
    sphereDetail(20);
  }
  
  void init(){
      num_cells=0;
      bugs.bacteria.clear();
      for(int i=0;i<500;i++){
      bugs.addBacterium(new Bacterium(new PVector(width*random(1),height*random(1),height*random(1)),cell_radius,rand_color(),false,false,growth_rate));
      num_cells++;
    }
  }
  void initBlue(){
    num_cells=0;
    bugs.bacteria.clear();
    for(int i=0;i<(int)(width/cell_radius);i++){
      for(int j=0;j<(int)(height/cell_radius);j++){
        bugs.addBacterium(new Bacterium(new PVector(i*cell_radius,j*cell_radius,0),cell_radius,new PVector(0,0,255),false,false,growth_rate));
      }
    }
  }
  void kick(){
     bugs.addBacterium(new Bacterium(new PVector(width*random(1),height*random(1),0),cell_radius,rand_color(),false,false,growth_rate));
  }
  void initCyl(){
    num_cells=0;
    bugs.bacteria.clear();
    for(int i=0;i<(int)(width/cell_radius);i++){
      for(int j=0;j<(int)(height/cell_radius);j++){
        for(int k=0;k<(int)(width/cell_radius);k++){
          float w=width/cell_radius;
          float h=height/cell_radius;
          float d= height/cell_radius;
          double x0=(w/2);
          double y0=(h/2);
          double r=Math.sqrt(Math.pow(i+1-x0,2)+Math.pow(k+1-y0,2));
          //x0=w/4;
          //double r2=Math.sqrt(Math.pow(1+i-x0,2)+Math.pow(j+1-y0,2));
          if(r<6){
            //if(i<(int)((width*3)/(cell_radius*4))&&i>(int)(width/(cell_radius*4))){
            bugs.addBacterium(new Bacterium(new PVector((i)*cell_radius,j*cell_radius,k*cell_radius),cell_radius,new PVector(255,0,0),false,false,growth_rate));
          }
        else{
          bugs.addBacterium(new Bacterium(new PVector(i*cell_radius,j*cell_radius,k*cell_radius),cell_radius,new PVector(0,0,255),false,false,growth_rate));
        }
        num_cells++;
      }
     }
    }
  }
      
   void tock(){
     tick=1-tick;
   }
      
  void keyPressed(){
    if(key=='i'){
      init();
    }
    if(key=='j'){
      initCyl();
    }
    if(key=='b'){
      initBlue();
    }
    if(key=='k'){
      kick();
    }
    if(key=='g'){
      growing=1-growing;
    }
    }
  
  void draw(){
    background(0);
    grid.reset(bugs.bacteria);
    //for(Bacterium b:grid.sites[6].contains){
    //  b.show();
    //}
    
    for(Bacterium b:bugs.bacteria){
      b.show();
      if(num_cells<max_num_cells&&growing==1){
      b.grow();
      }
      ArrayList<Bacterium> neighbors=new ArrayList<Bacterium>();
      int i=(int)(floor(b.r.x/grid_width));
      int j=(int)(floor(b.r.y/grid_height));
      int k=(int)(b.r.z/grid_depth);
      int I=(int)(floor(width/grid_width));
      int J=(int)(height/grid_height);
      for(int i1=-1;i1<=1;i1++){
        for(int j1=-1;j1<=1;j1++){
          for(int k1=-1;k1<=1;k1++){
            if(i+i1>=0&&j+j1>=0&&k+k1>=0){
              int h=grid.flat(i+i1,j+j1,k+k1,I,J);
              for(Bacterium bob:grid.sites[h].contains){
                neighbors.add(bob);
              }
             }
          }
        }
      }
      
      b.r.add(movement(b,neighbors,1.2*cell_radius,k).mult(eta*dt));
      
    }
    
    ArrayList<Bacterium> to_divide=new ArrayList<Bacterium>();
    Iterator<Bacterium> iter = bugs.bacteria.iterator();
    while (iter.hasNext()) {
      Bacterium b = iter.next();
      if (b.radius>cell_radius*Math.sqrt(2)*.75){
        if(random(1)>.99){
        to_divide.add(b);
        }
      }
    }
    
    ArrayList<Bacterium> to_kill=new ArrayList<Bacterium>();
    Iterator<Bacterium> iter2 = bugs.bacteria.iterator();
    while (iter2.hasNext()) {
      Bacterium b2 = iter2.next();
      if(b2.enemy_count*random(1)>kill_thresh){
        //if(random(1)>.999){
      to_kill.add(b2);
      }
    }
    
    bugs.update(to_divide,to_kill);
    
    }


float pb(int size,float x){ 
  int intpart=(floor(x)+size)%size;
  float floatpart=x-(int)x;
  return floatpart+intpart;
}

PVector movement(Bacterium bug, ArrayList<Bacterium> bacteria, float cut_off, float k){
  PVector f=new PVector(0,0,0);
  bug.enemy_count=0;
  for(Bacterium b:bacteria){
    PVector disp=PVector.sub(b.r,bug.r);
    if(disp.mag()<cell_radius){
      if(disp.mag()!=0){
        f.add((disp.add(disp.mult((bug.radius+b.radius)/disp.mag())).mult(-k)).mult(1));
      }
    }
    if(disp.mag()<cut_off){
      if(b.species_color.x!=bug.species_color.x){
        bug.enemy_count++;
      }
    }
    }
  return(f);
}
    

PVector rand_color(){
  if(random(1)>0.5){
    return(new PVector(255,0,0));
  }
  return(new PVector(0,0,255));
  //return(new PVector(random(255),random(255),random(255)));
}
      