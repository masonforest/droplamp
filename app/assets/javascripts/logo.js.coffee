$ ->
  $("#logo").html("")
  paper = Raphael("logo", 384, 100);
  paper.text(0,34,'KISS').attr({fill:"90-#000:0-#666", font:"80px myriad-pro","font-weight":"bold","text-anchor":"start"});
  paper.text(160,37,'r').attr({fill:"90-#006CCC:0-#006CCC", font:"70px myriad-pro","font-weight":"bold","text-anchor":"start"});
  
  #paper.text(0,34,'KISS').attr({fill:"90-#000:0-#666",font:"60px myriad-pro","font-weight":"bold","text-anchor":"start"});
  #paper.text(135,34,'r').attr({fill:"90-#000:0-#f55",font:"60px myriad-pro","font-weight":"bold","text-anchor":"start"});
