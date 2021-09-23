$fn=30;
top=false;
stem=false;
bottom=false;
leaf=false;
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

module roundedCylinder(d=2,r=0.2,h=3){
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
  h=2.5;
  bx=13.75;
  by=13.6;
  module main(){
    module sideClips(){
      difference(){
        translate([0,by/2+0.2/2,-h+3/2])
        hull(){
          cube([10.5,0.85,0.001],center=true);
          translate([0,0,-3.195])cube([10.3,0.85,0.001],center=true);
        }
        translate([0,by/2+0.4245,-h+1])cube([11,0.85,3],center=true);
        translate([0,by/2+0.99,-h-1.7])rotate([49.5,0,0])cube([11,2,2],center=true);
        
        translate([0,by/2,-h+0.445])hull(){
          cube([3.7,2,0.01],center=true);
          translate([0,0,-2.136])cube([3.85,2,0.01],center=true);
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
         translate([0,0,-0.3]){
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
    if(showGuides){
      #translate([0,0,-0.4])cube([1,13.6,3.3],center=true);
      #translate([0,0,-0.0])cube([13.75,1,2.5],center=true);
//      #translate([bx/4,by/2,0])cube([1,1,2.8],center=true);
      #translate([bx/2-0.5,-by/8,-0.249])cube([1,1,2],center=true);
      #translate([bx/2,-1,1])cube([1,1,0.5],center=true);
      #translate([0,by/2,0])cube([10.5,1,0.1],center=true);
      #translate([0,by/2,-2])cube([10.2,1,0.1],center=true);
      #translate([bx/5,by/2,-h/2-0.22])cube([1,1,5.45],center=true);
      #translate([bx/2-1,by/2,-h-0.199])cube([1,1,2.9],center=true);
//      #translate([bx/5,by/2,-h/2])cube([1,1,3.3],center=true);
      #translate([-bx/4,by/2-0.2,-0.7235])cube([1.2,1,2.95],center=true);
    }
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
  module middlePeg(d=3.2,ht=1.7,hb=1){
    hull(){
      translate([0,0,hb/2])cylinder(d=d,h=ht,center=true);
      translate([0,0,-ht/2])cylinder(d=d-1,h=hb,center=true);
    }
  }
  
  module sidePegHook(){
    hull(){
      cube([1,0.8,0.01],center=true);
      translate([0,-0.4,0.8])cube([1,0.01,0.01],center=true);
    }
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
      translate([-0.1,0,h/2-2.899]){
        translate([-0.2,0,0])linear_extrude(2.901)stemprofile();
        translate([0.4,0,0])linear_extrude(2.901)stemprofile(0,5.25);
      }
      
      
      // Leaf place
      translate([bx/2-5/2-0.751,0,h/2-1.2/2]){
        rube([5,2,1.2],center=true);
        translate([0,0,1.2/2])rube([5,2,1.2],center=true);
      }
      translate([bx/2-0.9115,1.45,0.5])cube([0.32,6.4,h],center=true);
      translate([bx/2-1.98,0.04,h/2-0.2])rube([1,9,2],center=true);
      //Leaf leg cut
      translate([bx/2-0.9115,0,0])cube([0.32,0.95,h+2],center=true);
      translate([4.25,by/3-0.14,0.5]){
        translate([0.5,0,0])rube([2,1.5,h],center=true);
        translate([0.7,-0.25,0])rube([2.3,1,h],center=true);
        translate([0.7,0.25,0])rube([1.2,1,h],center=true);
        translate([1.377,0.249,0])roundedCylinder(d=1,h=h);

      }
      translate([bx/2-2.63,by/2-3.7,h/2-0.198]){
        rube([1,2,2],center=true);
        translate([0.325,-0.2,0])rube([1.65,1,h],center=true);
      }
      
      translate([bx/2-1.98,1.5,1])rube([1,1.3,h],center=true);
      translate([bx/2-1.98,-1.3,1])rube([1,0.9,h],center=true);
      
      // Right leaf
      translate([bx/2-3.15,-by/2+3.4,h/2-0.2]){
        translate([0.05,-0.3,-1])rube([0.55,3.3,h],center=true);

        
        // Leaf leg cut
        translate([0,-1.53,0])cube([0.45,0.85,h*2],center=true);

        
        translate([1.1,0.14,0])rube([2.5,2.4,2],center=true);
        translate([0,-0.5,0]){
          translate([1.425,0.295,0])rube([1,3.09,h],center=true);
          translate([1.575+0.3,0.84,0])rube([1.2,2,h],center=true);
          translate([1.575+0.294,0,0])rube([0.7,2.5,h],center=true);
          translate([1.575+0.55,0,0])rube([0.7,2,h],center=true);
          translate([1.575+0.4,-0.75,0])roundedCylinder(d=1,h=h);
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
      translate([-tw/3-1.625,0,-h/2])cube([tw/2,tw,0.1],center=true);
      translate([tw/3+1.625,0,-h/2])cube([tw/2,tw,0.1],center=true);
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
      h=2.8;
      cylinder(d=w,h=h,center=true);
      cylinder(d=w-0.4,h=h+1,center=true);
    }
    
    // Clickbar guard
    translate([-2.775,-2.3,h/2+0.65/2]){
      x=0.55;
      hull(){
        cube([x,0.6,0.65],center=true);
        translate([0,0.7,-0.4])cube([x,0.6,0.1],center=true);
      }
      hull(){
        translate([0,0,0.3])cube([x,0.6,0.1],center=true);
        translate([-0.4,0,0])cube([x,0.6,0.1],center=true);
      }
    }
    
 
    // little side peg hooks
    {
      spacing=bx/4;
      side=by/2-0.36;
      hp=h/2-0.81;
      translate([spacing,side,hp])sidePegHook();
      translate([-spacing,side,hp])sidePegHook();
      
      translate([spacing,side*-1,hp])rotate([0,0,180])sidePegHook();
      translate([-spacing,side*-1,hp])rotate([0,0,180])sidePegHook();
    }
   
  }
  #if(showGuides){
    translate([1,0,-1.4])cube([1,1,2.8]);
    translate([0,0,-h/2-2.7]){
//      cube([tw,tw,0.1],center=true);
      cube([1,12.5,0.1],center=true);
      cube([1,9.3,0.3],center=true);
    }
    translate([bx/4.265,-by/2+1.67,-h/2])cube([0.7,1.2,1],center=true);
    
    translate([0,-4,h/2+0.3])cube([5,1,1],center=true);
    
    translate([0,3,-h/2])cube([5.75,1,1],center=true);
   
    translate([bx/2-0.525,by/2-0.0255,h/2]){
      cube([2.25,3,1],center=true);
      cube([5,1.45,1],center=true);
    }
  
    translate([-tw/4,by/2-1.2,h/2])cube([4,0.9,1],center=true);
    translate([-tw/4,by/3-0.4,h/2])cube([4,0.5,1],center=true);
    translate([-tw/4-0.6,by/2-2.575,h/2])cube([0.4,3.65,1],center=true);
   
    translate([-bx/2+3.8/2-0.625,by/5+0.03,h/2])cube([3.8,0.7,1],center=true);
    translate([bx/2-4.9/2+0.625,by/4,h/2])cube([4.9,1,1],center=true);
    
    translate([3.175,0,h/2]){
      translate([0,by/2-by/5-0.3,0])cube([1.15,by/3,1],center=true);
      translate([-0.175,-by/2+by/5+0.3,0])cube([1,by/3,1],center=true);
    } #translate([bx/2-3.9/2+0.625,0,h/2])cube([3.9,1,1],center=true);
    translate([bx/2-4.15/2+0.625,0,h/2])cube([4.15,1,1],center=true);
    // Thickness of outer wall
    translate([bx/2-0.025,0,h/2])cube([1.3,by,1],center=true);
    
    //From edge to inner wall in spring area
    translate([bx/2-0.0751-0.35,0,h/2])cube([2.1,by,1],center=true);
    translate([bx/2-1,-tw/2+5.75/2,h/2])cube([2.1,5.75,1],center=true);
   
    { // Right leaf little peg guide
        translate([bx/2-2.525,-by/2+1.55,h/2])cube([0.6,1.6,1],center=true);
        translate([bx/2-1.1,-by/2+1.55,h/2])cube([3.45,1.6,1],center=true);
      }
    translate([bx/2-0.0751-1.2,0,h/2])cube([0.4,by,1],center=true);
    translate([0,by/2-1.2,h/2])cube([tw,0.9,1],center=true);
      
    translate([0,-by/2+1.1,h/2])cube([tw,0.7,1],center=true);
    translate([0,by/2-0.425,h/2-1])cube([4,0.65,1],center=true);
    translate([-bx/2+0.75,-by/5-0.3039,h/2])cube([2.75,0.75,1],center=true);
    translate([-bx/5,0,h/2])cube([0.6,tw,1],center=true);
    translate([-bx/2-0.02,0,h/2])cube([1.2,7,1],center=true);
    translate([-bx/2+0.325,-by/3,h/2])cube([1.9,2,1],center=true);
    
    translate([-3,0,-h/2])cube([1,11.45,1],center=true);
    translate([6.5,0,0])cube([1,1,3],center=true);
  }
}

module leaf(){
  module right(){
    rotate([0,90,0])
    mirror([0,1,0])
    union(){
      translate([-7.1/4,0,-0.2])
      linear_extrude(0.4)
      ooo(){
        difference(){
          union(){
            square([3.2,3.3],center=true);
            hull(){
              translate([6.5/2-3.2/2,3.3/2-0.8/2,0])square([6.5,0.8],center=true);
              translate([5.2,3.3/2-0.8/2,0])square([0.6,0.4],center=true);
            }
          }
          translate([-1,1.5,0])square([2,0.4],center=true);
          translate([0,1.6,0])rotate([0,0,-45])square([0.3,0.5],center=true);
        }
      }
      translate([-7.1/3,-3.3/3,0.15])rube([1,0.6,0.7],center=true);
    }

  }
  
  module left(){
    translate([0,0,7.1/2.9])union(){
      translate([0,7.7/2,-1.8/2])
      linear_extrude(1.8)
      union(){
        difference(){
          circle(d=1.6);
          circle(d=1.4);
          translate([0,-1,0])square([2,2],center=true);
        }
        translate([0.75,-2.93,0])square([0.1,5.85],center=true);
        translate([-0.75,-3.95,0])square([0.1,7.9],center=true);
      }
      
      translate([-0.7,-3,0])difference(){
        rube([0.3,1 ,0.6],center=true);
        translate([0.1,0,0])cube([0.4,1 ,0.6],center=true);
      }
      

      translate([0.7,-1.305,-1.124])
      rotate([0,90,0])
      linear_extrude(0.1)
      ooo()square([2.65-1.4,1.4],center=true);
      
      translate([0.7,1.4,-0.8])
      rotate([0,90,0])
      linear_extrude(0.1)
      ooo()square([3.4,4],center=true);
      
      translate([0.7,-0.21,-7.1/2.68])
      rotate([0,90,0])
      linear_extrude(0.1)
      hull(){
        p=6.6;
        square([p-0.5,0.9],center=true);
        translate([(p-0.5)/2+0.5/2,0,0])square([0.5,0.45],center=true);
      }
      
      translate([-1,-0.2,0]){
        rube([1.6,1.2,2.3],center=true);
        hull(){
          rube([1.6,1.2,0.1],center=true);
          translate([-0.3,0,0.65])rube([2.2,1.2,1],center=true);
        }
      }
      
      
//    #translate([0,1.32,0])square([2,6.65],center=true);
//    #translate([0,0.3,0])square([2,8.7],center=true);
//      #translate([0.9,-1.4,-0.4245])cube([1,1,2.65],center=true);
//      #translate([0.9,-0.3,-7.1/2.68])cube([1,1,7.1],center=true);
    }
  }
  
  x=0.75;
  y=1.95;
  translate([x,y,0])left();
  translate([-x,-y,0])right();
}

module switch(){
  if(top){color([1,1,1])translate([0,0,2.75])top();}
  if(stem){color([0.3,0.7,1])translate([0,0,1.4])stem();}
  if(bottom){color([0.2,0.2,0.2])bottom();}
  if(leaf){color([0.8,0.8,0])translate([4.5,-1.74,-1])leaf();}
}



switch();
