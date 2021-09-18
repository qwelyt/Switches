$fn=30;
showGuides=false;
module ooo(r=0.1){
  offset(r)offset(-(r*2))offset(r)children();
}

module rube(size=[1,1,1],center=false,r=0.2,type="s"){
  module s(){sphere(r=r);}
  module c(){cylinder(r=r,h=r*2,center=true);}
  module m(){
    if(type == "c"){
      c();
    } else {
      s();
    }
  }
  
  tx=size[0] - r;
  ty=size[1] - r;
  tz=size[2] - r;


  cntr = center ? [-(tx/2+r/2),-(ty/2+r/2), -(tz/2+r/2)] : [0,0,0];
  
  translate(cntr)hull(){
    //bottom
    translate([r,r,r])m();
    translate([tx,r,r])m();
    translate([r,ty,r])m();
    translate([tx,ty,r])m();
    
    //top
    translate([r,r,tz])m();
    translate([tx,r,tz])m();
    translate([r,ty,tz])m();
    translate([tx,ty,tz])m();
  }
}

module bullet(d=2,r=0.2,h=3){
  rr=r*2;
  
  cylinder(h=h-rr,d=d,center=true);
  
  translate([0, 0, h/2-rr/2]){
    rotate_extrude()translate([(d-rr)/2, 0, 0])circle(d=rr);
    translate([0,0,-rr/2])cylinder(d=d-rr,h=rr);
  }

  translate([0, 0, -h/2+rr/2]){
    rotate_extrude()translate([(d-rr)/2, 0, 0])circle(d=rr);
    translate([0,0,-rr/2])cylinder(d=d-rr,h=rr);
  }
}
module stemprofile(extra=0,notch=5.6){
  ooo(){
    x=4.4+extra;
    y=10.2+extra;
    x2=notch+extra;
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

module bottom(){
  tw=15;
  bx=13.75;
  by=13.6;
  h=0.8+1+1.2;
  module undersidePegOnTop(){
    translate([0,0,1.5])cylinder(d=1,h=0.8,center=true);
  }
  module sideCutForClips(){
    cube([3.5,1.451,h+2],center=true);
    hull(){
      cube([3.5,1.451,h/2],center=true);
      translate([0,0,-h/2])cube([3.5,2.1,0.01],center=true);
    }
  }
  
  module sidePegHook(){
    rotate([90,0,0])
    rotate([0,90,0])
    cylinder($fn=3,h=1,d=0.8,center=true);
  }
  union(){
    difference(){
      union(){ // main block
        translate([0,0,0.7])linear_extrude(0.8)ooo(2)square([tw,tw],center=true);
        translate([0,0,-0.3])linear_extrude(1)ooo(2)square([13.8,13.6],center=true);
        
        translate([0,0,-0.3])hull(){
          translate([0,0,0])linear_extrude(0.01)ooo(2)square([13.8,13.6],center=true);
          translate([0,0,-1.2])linear_extrude(0.01)ooo(2)square([13.1,13.1],center=true);
        }
      }
      
      // holes for the little pegs on the underside of the top
      translate([bx/2-0.8,by/2-0.8,0])undersidePegOnTop();
      translate([-bx/2+0.8,by/2-0.8,0])undersidePegOnTop();
      translate([bx/2-0.8,-by/2+0.8,0])undersidePegOnTop();
      translate([-bx/2+0.8,-by/2+0.8,0])undersidePegOnTop();
      
      // Big hole for diodes
      translate([-tw/2+3.25/2+1.2,-0.125,0])rube([3.25,5.05,5],center=true);
      // clickbar holder
      translate([-tw/2+3.2/2+1.2,-by/3.128,h/2-2.5/2+0.2])hull(){
        rube([1.8,1.9,2.7],center=true);
        translate([1.9/4.07,0,1.1])linear_extrude(0.01)ooo(0.2)square([2.4,1.9],center=true);
      }
      translate([-tw/3+0.75,-2.6,h/2-2.298/2])cube([1,2,2.5],center=true);
      
      // Other side of diode
      translate([-tw/4.167,by/3-0.41,h/2-2.298/2]){
        rube([1.1,2.05,2.7],center=true);
        translate([-1.35,0.63,0])rube([0.8,0.8,2.7],center=true);
        translate([-1.35,-0.63,0])rube([0.8,0.8,2.7],center=true);
        translate([0.225,-1,0.5])cube([0.65,2,1.5],center=true);
      }
      
      // Mid to diode/clickbar connector
      translate([-tw/5,-3.1,h/2-2.897/2])cube([2,1,2.901],center=true);
      
      

      

      // Top mid cross cut
      translate([0,0,h/2-0.85/2]){
        translate([0,0,(0.85/2)-2.899/2])cube([2.4,by-1.498,2.901],center=true);
        translate([0,by/2+0.75,0])cube([5,3,0.86],center=true);
        translate([0,-by/2-0.75,0])cube([5,3,0.86],center=true);
      }
      
      // Mid hollower
      translate([0,0,h/2-2.899]){
        linear_extrude(2.901)stemprofile(0.1);
        translate([0.15,0,0])linear_extrude(2.901)stemprofile(0.1);
        translate([-0.2,0,0])linear_extrude(2.901)stemprofile(0.1);
        translate([0.35,0,0])linear_extrude(2.901)stemprofile(0.1,5);
      }
      
      
      // Leaf place
      translate([bx/2-5/2-0.751,0,h/2-1.2/2]){
        rube([5,2,1.2],center=true);
        translate([0,0,1.2/2])rube([5,2,1.2],center=true);
      }
      translate([bx/2-0.9115,1.45,0.5])cube([0.32,6.4,h],center=true);
      translate([bx/2-1.98,0.04,h/2-0.2])rube([1,9,2],center=true);
      translate([bx/2-0.9115,0,0])cube([0.32,1.4,h+2],center=true);
      translate([4.25,by/3-0.14,0.5]){
        translate([0.5,0,0])rube([2,1.5,h],center=true);
        translate([0.7,-0.25,0])rube([2.3,1,h],center=true);
        translate([0.7,0.25,0])rube([1.2,1,h],center=true);
        translate([1.377,0.249,0])bullet(d=1,h=h);

      }
      translate([bx/2-2.63,by/2-3.7,h/2-0.198]){
        rube([1,2,2],center=true);
        translate([0.325,-0.2,0])rube([1.65,1,h],center=true);
      }
      
      translate([bx/2-1.98,1.5,1])rube([1,1.3,h],center=true);
      translate([bx/2-1.98,-1.3,1])rube([1,0.9,h],center=true);
      
      translate([bx/2-2.825,-by/2+3.4,h/2-0.2]){
        translate([0,-0.2,-1]){
          rube([0.7,3.08,h],center=true);
          translate([0,-1,-2])cube([0.3,0.8,h+2],center=true);
        }
        translate([0.925,0.14,0])rube([2.55,2.4,2],center=true);
        translate([0.7+0.6,-0.5,0]){
          translate([0,0.295,0])rube([0.7,3.09,h],center=true);
          translate([0.3,0.84,0])rube([1.2,2,h],center=true);
          translate([0.294,0,0])rube([0.7,2.5,h],center=true);
          translate([0.55,0,0])rube([0.7,2,h],center=true);
          translate([0.4,-0.75,0])bullet(d=1,h=h);
        }
      }
      
      
      
      
          
      // Side cuts for clips
      translate([bx/4+0.04,by/2-0.025,0])sideCutForClips();
      translate([bx/4+0.04,-by/2+0.025,0])sideCutForClips();
      translate([-bx/4-0.04,by/2-0.025,0])sideCutForClips();
      translate([-bx/4-0.04,-by/2+0.025,0])sideCutForClips();
      
      translate([0,by/2+0.4,0])cube([6,1,2],center=true);
      translate([0,-by/2-0.4,0])cube([6,1,2],center=true);
      
  //    translate([0,0,2.765])top();
      
      // Bottom
      translate([-tw/3-1,0,-h/2])cube([tw/2,tw,0.1],center=true);
      translate([tw/3+1,0,-h/2])cube([tw/2,tw,0.1],center=true);
    }
    
    translate([0,0,-h/2])linear_extrude(0.1)stemprofile(0.1);
    
    // Bottom pegs
    translate([0,0,-h+0.2]){
      middlePeg(3.2);
      k=1.35;
      translate([0,by/2-k,0])middlePeg(1.6);
      translate([0,-by/2+k,0])middlePeg(1.6);
    }
    
    // Middle cylinder
    difference(){
      w=2.6;
      h=3;
      cylinder(d=w,h=h,center=true);
      cylinder(d=w-0.4,h=h+1,center=true);
    }
    
    // Clickbar guard
    translate([-2.75,-2.3,h/2+0.65/2]){
      hull(){
        cube([0.6,0.6,0.65],center=true);
        translate([0,0.7,-0.4])cube([0.6,0.6,0.1],center=true);
      }
      hull(){
        translate([0,0,0.3])cube([0.6,0.6,0.1],center=true);
        translate([-0.4,0,0])cube([0.6,0.6,0.1],center=true);
      }
    }
    
 
    // little side peg hooks
    {
      spacing=bx/4;
      side=by/2-0.6;
      hp=h/2-0.4;
      translate([spacing,side,hp])sidePegHook();
      translate([-spacing,side,hp])sidePegHook();
      
      translate([spacing,side*-1,hp])rotate([180,0,0])sidePegHook();
      translate([-spacing,side*-1,hp])rotate([180,0,0])sidePegHook();
    }
   
  }
  if(showGuides){
    #translate([0,0,-h/2-2.7]){
      cube([tw,tw,0.1],center=true);
      cube([1,12.5,1],center=true);
      cube([1,9.3,2],center=true);
    }
   
    #translate([bx/2-0.525,by/2-0.0255,h/2]){cube([2.25,3,1],center=true);cube([5,1.45,1],center=true);}
  
   #translate([-tw/4,by/2-1.2,h/2])cube([4,0.9,1],center=true);
    #translate([-tw/4,by/3-0.4,h/2])cube([4,0.5,1],center=true);
    #translate([-tw/4-0.6,by/2-2.575,h/2])cube([0.4,3.65,1],center=true);
   
    #translate([-bx/2+3.8/2-0.625,by/5+0.03,h/2])cube([3.8,0.7,1],center=true);
  #translate([bx/2-4.9/2+0.625,by/4,h/2])cube([4.9,1,1],center=true);
    
    #translate([3.175,0,h/2]){
      translate([0,by/2-by/5-0.3,0])cube([1.15,by/3,1],center=true);
      translate([-0.025,-by/2+by/5+0.3,0])cube([1.1,by/3,1],center=true);
    }
  #translate([bx/2-3.9/2+0.625,0,h/2])cube([3.9,1,1],center=true);
    #translate([bx/2-0.0751,0,h/2])cube([1.4,by,1],center=true);
    
    #translate([bx/2-0.0751-0.35,0,h/2])cube([2.1,by,1],center=true);
    #translate([bx/2-1,-tw/2+5.75/2,h/2])cube([2.1,5.75,1],center=true);
    #translate([bx/2-2.18,-by/2+1.55,h/2])cube([0.6,1.6,1],center=true);
    #translate([bx/2-0.0751-1.2,0,h/2])cube([0.4,by,1],center=true);

    #translate([0,by/2-1.2,h/2])cube([tw,0.9,1],center=true);
    #translate([0,-by/2+1.2,h/2])cube([tw,0.9,1],center=true);
    #translate([0,by/2-0.425,h/2-1])cube([4,0.65,1],center=true);
    #translate([-bx/2+0.75,-by/5-0.3039,h/2])cube([2.75,0.75,1],center=true);
  #translate([-bx/5,0,h/2])cube([0.6,tw,1],center=true);
  #translate([-bx/2-0.02,0,h/2])cube([1.2,7,1],center=true);
  #translate([-bx/2+0.325,-by/3,h/2])cube([1.9,2,1],center=true);
 

  #translate([3,0,-h/2])cube([1,11.45,1],center=true);
//  #square(15,center=true);
  #translate([6.5,0,0])cube([1,1,3],center=true);
 }
}

module switch(){
//  #translate([0,0,3])top();
//  #stem();
  bottom();
}

module middlePeg(d=3.2,ht=1.7,hb=1){
  hull(){
    translate([0,0,hb/2])cylinder(d=d,h=ht,center=true);
    translate([0,0,-ht/2])cylinder(d=d-1,h=hb,center=true);
  }
}


switch();
