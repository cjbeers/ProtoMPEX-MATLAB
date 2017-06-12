function [helicon_current,current_A,current_B,config,skimmer,current_C] = get_Proto_current(shot)

current_C = 0;

switch shot
    case 5954
        helicon_current = 0; current_A = 3300; current_B = 3300; config = 'standard'; skimmer = 0;

    case 6547
        helicon_current = -80; current_A = 6600; current_B = 6600; config = 'focus'; skimmer = 0;        
    case 6550
        helicon_current = -140; current_A = 6600; current_B = 6600; config = 'focus'; skimmer = 0;

        
    case 7400
        helicon_current = 30; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7403
        helicon_current = 60; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7404
        helicon_current = 90; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7405
        helicon_current = 120; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7406
        helicon_current = 150; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7408
        helicon_current = 180; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7410
        helicon_current = 210; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7412
        helicon_current = 240; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7413
        helicon_current = 270; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7416
        helicon_current = 300; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7417
        helicon_current = 350; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
    case 7418
        helicon_current = 400; current_A = 6368; current_B = 0; config = 'flat'; skimmer = 0;
        
    case 7445
        helicon_current = 210; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 0;

    % Half field, no skimmer, helicon current scan
    case 7277
        helicon_current = 300; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 0;
    case 7278
        helicon_current = 350; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 0;
        
    % Half field, skimmer, helicon current scan
    case 7477
        helicon_current = 30; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;
    case 7483
        helicon_current = 60; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;
    case 7487
        helicon_current = 90; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;
    case 7488
        helicon_current = 120; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;    
    case 7492
        helicon_current = 150; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;   
    case 7493
        helicon_current = 180; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;         
    case 7494
        helicon_current = 210; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;              
    case 7495
        helicon_current = 240; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;               
    case 7496
        helicon_current = 270; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;               
    case 7497
        helicon_current = 300; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;                        
    case 7498
        helicon_current = 350; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;              
    case 7500
        helicon_current = 400; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;                
    case 7501
        helicon_current = 500; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1;                
    case 7503
        helicon_current = 600; current_A = 3300; current_B = 0; config = 'flat'; skimmer = 1; 
    case 11682
        helicon_current = 260; current_A = 5900; current_B = 5900; config = 'flat'; skimmer = 1; 
    case 13703
        helicon_current = 190; current_A = 4000; current_B = 4000; current_C = 600; config = 'flat'; skimmer = 1; 
        
        
    case {13936, 13937, 13938, 13939}
        helicon_current = 160; current_A = 6000; current_B = 6000; current_C = 600; config = 'flat'; skimmer = 1;  %MS edit, 4/18/17

    case num2cell(14085:14148)
    helicon_current = 160; current_A = 4000; current_B = 4000; current_C = 600; config = 'flat'; skimmer = 1;  %MS edit, 4/24/17
    case 14159
    helicon_current = 160; current_A = 4000; current_B = 4000; current_C = 600; config = 'flat'; skimmer = 1;  %MS edit, 4/24/17
    % Half field, no skimmer, helicon current scan
    case num2cell(14700:14900)
    helicon_current = 160; current_A = 4000; current_B = 4000; current_C = 600; config = 'newstandard'; skimmer = 1;  %MS edit, 4/24/17
       case 7674
        helicon_current = 400; current_A = 6400; current_B = 0; config = 'flat'; skimmer = 1;
        
    case {7670, 7680, 7687}
        helicon_current = 210; current_A = 6400; current_B = 0; config = 'flat'; skimmer = 1;        
              
    otherwise
        error(['Did not recognize shot: ',num2str(shot)])
end
if skimmer
    fprintf('This shot includes skimmer\n')
end
