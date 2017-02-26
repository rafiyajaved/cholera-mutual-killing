class Site {
  
  PVector origin;
  float grid_height;
  float grid_width;
  ArrayList <Bacterium> contains;
  
  Site(){
    contains=new ArrayList<Bacterium>();
  }
  
  void addBacterium(Bacterium b) {
    contains.add(b);
  }
  void removeBacterium(Bacterium b){
    contains.remove(b);
  }
  void clearBacteria(){
    contains.clear();
  }
}

class Grid{
  
  Site[] sites;
  float grid_height;
  float grid_width;
  float grid_depth;
  int len;
  
  Grid(float temp_grid_height ,float temp_grid_width,float temp_grid_depth){
    grid_height=temp_grid_height;
    grid_width=temp_grid_width;
    grid_depth=temp_grid_depth;
    len=100060; //a big number
    sites=new Site[len];
    for(int h=0;h<len;h++){
      sites[h]=new Site();
    }
  }
  
  int flat(int i, int j, int k, int I, int J){
    // returns list index given 3D indices (i,j,k) and array cross section dimensions I,J
    return((I*J*k)+(I*j)+i);
  }
  
  void reset(ArrayList<Bacterium> bacteria){
    for(int h=0;h<len;h++){
      sites[h].contains.clear();
    }
    
    for(Bacterium b:bacteria){
      int i=(int)(b.r.x/grid_width);
      int j=(int)(b.r.y/grid_height);
      int k=(int)(b.r.z/grid_depth);
      int I=(int)(width/grid_width);
      int J=(int)(height/grid_height);
      int siteInd=flat(i,j,k,I,J);
      if(siteInd>=0){
      sites[siteInd].addBacterium(b);
      }
    }
  }
}


    
  