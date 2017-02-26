class Bacterium {
  PVector r;
  ArrayList<Bacterium> neighborhood;
  PVector next_position;
  float radius;
  PVector species_color;
  boolean divided;
  boolean killed;
  float clock;
  float growth_rate;
  int enemy_count;
  
  Bacterium( PVector r, float radius, PVector species_color, boolean divided, boolean killed,float growth_rate){
    this.r=r;
    this.neighborhood=neighborhood;
    this.next_position=next_position;
    this.radius=radius;
    this.species_color=species_color;
    this.divided=divided;
    this.killed=killed;
    this.clock=clock;
    this.growth_rate=growth_rate;
  }
  
  void show(){ //bug displays itself (also sets position to toroidal wrapping conditions)
    r.x=Math.min(width,r.x);
    r.x=Math.max(0,r.x);
    r.y=Math.min(height,r.y);
    r.y=Math.max(0,r.y);
    r.z=Math.min(height,r.z);
    r.z=Math.max((height/2),r.z);
    if(species_color.x==255){
      fill(species_color.x,species_color.y, species_color.z,40);
    
    stroke(100);
    pushMatrix();
    translate(r.x, r.y,r.z);
    sphere(radius);
    //ellipse(r.x,r.y,radius,radius);
    popMatrix();
  }
  //else{
  //  fill(species_color.x,species_color.y, species_color.z,30);
  //  noStroke();
  //  pushMatrix();
  //  translate(r.x, r.y,r.z);
  //  sphere(radius);
  //  popMatrix();  
  //}
  }
  
  void grow(){
    radius=radius+(2*(float)Math.PI*dt*growth_rate)/radius;
  }
  
}