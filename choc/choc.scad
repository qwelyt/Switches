$fn=30;
module ooo(r=0.1){
  offset(r)offset(-(r*2))offset(r)children();
}

module rube(size=[1,1,1],center=false,r=0.2){
  module s(){sphere(r=r);}
  
  tx=size[0] - r;
  ty=size[1] - r;
  tz=size[2] - r;


  cntr = center ? [-(tx/2+r/2),-(ty/2+r/2), -(tz/2+r/2)] : [0,0,0];
  
  translate(cntr)hull(){
    //bottom
    translate([r,r,r])s();
    translate([tx,r,r])s();
    translate([r,ty,r])s();
    translate([tx,ty,r])s();
    
    //top
    translate([r,r,tz])s();
    translate([tx,r,tz])s();
    translate([r,ty,tz])s();
    translate([tx,ty,tz])s();
  }
}

module stemprofile(extra=0){
  ooo(){
    x=4.4+extra;
    y=10.2+extra;
    x2=5.6+extra;
    y2=3+extra;
    square([x,y],center=true);
    translate([(x2-x)/2,0,0])square([x2,y2],center=true);
    }
}

module top(){
  h=2.53;
  bx=13.75;
  by=13.6;
  module main(){
    module sideClips(){
      difference(){
        translate([0,by/2+0.2/2,-h])translate([0,0,3/2])hull(){
          cube([10.5,0.85,0.001],center=true);
          translate([0,0,-3])cube([10.3,0.85,0.001],center=true);
        }
        translate([0,by/2+0.4245,-h+1])cube([11,0.85,3],center=true);
        translate([0,by/2+0.99,-h-1.5])rotate([49.5,0,0])cube([11,2,2],center=true);
        
        translate([0,by/2,-h+0.704])hull(){
          cube([3.7,2,0.01],center=true);
          translate([0,0,-2.2])cube([3.85,2,0.01],center=true);
        }
      }
    }
    module undersidePeg(){
      translate([0,0,-h/2])cylinder(d=0.9,h=0.4,center=true);
    }
    
    module tinyTopPeg(){
      hull(){
        cube([0.5,0.5,0.5],center=true);
        translate([-0.5,0,-0.249])cube([0.5,0.5,0.01],center=true);
      }
    }
    
    union(){
      difference(){
        union(){
          // Main block
          hull(){
            p=0.14;
            translate([0,0,h/2-p*1.5])rube([13,12.4,p],center=true,r=p);
            translate([0,0,-h/2+p*1.5])rube([bx,by,p],center=true,r=p);
          }
          sideClips();
          mirror([0,1,0])sideClips();

          // little pegs on the underside
          translate([bx/2-0.8,by/2-0.8,0])undersidePeg();
          translate([-bx/2+0.8,by/2-0.8,0])undersidePeg();
          translate([bx/2-0.8,-by/2+0.8,0])undersidePeg();
          translate([-bx/2+0.8,-by/2+0.8,0])undersidePeg();
  //        #translate([bx/2-1.25/2,by/2-1.25/2,-h/2])cube([1.25,1.25,1],center=true);
        }
        
        // Top cuts
        translate([-4.8,0,h/2+0.5])rube([4,13,2],center=true);
        translate([4.8,0,h/2+0.5])rube([4,13,2],center=true);
        
        // Stemhole
        translate([0,0,-h])linear_extrude(h*2)stemprofile(0.3);
        
        // Underside clickbar space
        hh=h-0.8;
        translate([-13/2+2,0,-h/2+0.2]){
          rube([2.8,7.5,hh],center=true);
          translate([-0.6,13/2-2,0])rube([1.6,0.75,hh],center=true);
          translate([-0.6,-13/2+2,0])rube([1.6,0.75,hh],center=true);
        }
        
        // Underside activator space
        translate([13/2-2,0,-h/2+0.2])rube([2.4,10.6,hh],center=true);
        
        
        // clickbar peg hole
        hull(){
          translate([-2.6,-3.1,-h/2])cube([3,1,0.1],center=true);
          translate([-2,-3.1,h/2])cube([1,1,0.1],center=true);
        }
        hull(){ // The slope
          translate([-2.6,-1.2,-h/2-1])cube([3,3,0.1],center=true);
          translate([-2.6,-2.2,-h/2+0.5])cube([3,1,0.1],center=true);
        }
        
        // Underside side pegs
        translate([0,bx/2-3/2,-h/2+0.5/2]){
          cube([2.35,1,0.5],center=true);
          translate([0,0.07,0])cube([0.4,0.41,h*3],center=true);
        }
        translate([0,-bx/2+3/2,-h/2+0.5/2]){
          cube([2.35,1,0.5],center=true);
          translate([0,-0.07,0])cube([0.4,0.41,h*3],center=true);
        }
      
       { // side pegs
         y = (by-12.2)/2;
         hc=2.8+1;
         translate([0,0,-0.633+1/2]){
           translate([bx/4,by/2-y/2,0])cube([1.2,y,hc],center=true);
           translate([-bx/4,by/2-y/2,0])cube([1.2,y,hc],center=true);
           
           translate([bx/4,-by/2+y/2,0])cube([1.2,y,hc],center=true);
           translate([-bx/4,-by/2+y/2,0])cube([1.2,y,hc],center=true);
         }
       }
      }
      translate([-4.4/2-0.8,10.2/2-0.1,1.0142])tinyTopPeg();
      translate([-4.4/2-0.8,-10.2/2+0.1,1.0142])tinyTopPeg();

    }
//    #translate([bx/4,by/2,0])cube([1,1,2.8],center=true);
  //  #cube([1,13.6,5],center=true);
  //  #translate([7,0,0])cube([1,1,2.53],center=true);
//    #translate([0,by/2,0])cube([10.5,1,0.1],center=true);
//    #translate([0,by/2,-2])cube([10.2,1,0.1],center=true);
  }
  
  main();

}

module stem(){
  module c(){
    linear_extrude(4.7)
    ooo()
    square([2.9,1.15],center=true);
  }
  
  union(){
    difference(){
      union(){
        // Main box
        linear_extrude(4.7)stemprofile();
        
        //side pegs
        translate([0,0,0.3])cube([2,10.8,0.6],center=true);
          
        // clickbar peg
        translate([-3.5,-(10.2-8.8)*2,0])
        rotate([90,0,0])
        linear_extrude(0.6)
        difference(){
          square([5.7-4.4, 2]);
          rotate([0,0,57])square([8,8]);
        }
      }
      
      // Cap holes
      translate([0,0,0.7]){
        mv = 10.2/3.6;
        translate([0,-mv,0])c();
        translate([0,mv,0])c();
      }
      
      // cut for activator
      hull(){
        translate([5.6/2+0.2501,0,0.2/2+4.7-0.2-0.6])cube([0.7,1.9,0.2],center=true);
        translate([5.6/2+0.401,0,0.2/2])cube([0.4,1.9,0.201],center=true);
      }
      
      // Spring hole
      translate([0,0,-0.001])cylinder(d=3.9,h=4.001);
    }
    // stempole
    translate([0,0,1.2])cylinder(d=1.7,h=7,center=true);
  }
  //  cube([1,6.83,10],center=true);
  //  cube([1,4.5,11],center=true);

  
}

module bottom(){}

module switch(){
//  top();
  stem();
  bottom();
}

switch();