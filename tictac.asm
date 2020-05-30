;//////////////////////////////////////////////////////////////////
;//  Tic Tac Toe in x86 assembly to be made into a Linux elf_i386
;//  CISC211
;//  
;//////////////////////////////////////////////////////////////////

section .data
    textTopRow: db '   1 2 3',10,0
    textFirstRow: db ' A ',0
    textSecondRow: db ' B ',0
    textThirdRow: db ' C ',0
    textPlayerOneTurn: db 'It is Player Ones Turn.',10,0
    textPlayerTwoTurn: db 'It is Player Twos Turn.',10,0
    textInstructions: db 'Please select a space to mark, Ex A1 or B3',10,0
    textWinnerPlayerOne: db 'Player One has won!',10,0
    textWinnerPlayerTwo: db 'Player Two has won!',10,0
    textWinnerPlayerTie: db 'The game was a draw!',10,0
    textPlayAgain: db 'Would you like to play again?',10,0
    textSpace: db ' ',0
    textNewline: db '',10,0

section .bss
    inputBuffer: resb 64
    resb 4
    charBuffer: resb 1
    resb 1
    gameBoard: resb 16
    didGiveValidInput: resb 1
    isPlayerOnesTurn: resb 1
    doesWantToContinue: resb 1
    winnerStatus: resb 1
    xCoord: resb 1
    yCoord: resb 1

section .text
    GLOBAL _start

_start:
    ;There are many lines of C# litered throughout the code
	;This is because we coded the project in C# and then converted it
	;x86 assembly after. This allowed us to complete it while keeping
	;our goals clear and focused.
	
	;doesWantToContinue = true;
    mov byte [doesWantToContinue],0x01
    ;while(doesWantToContinue)
    whileDoesWantToContiueLoop:
    cmp byte [doesWantToContinue],0x01
    jne whileDoesWantToContiueLoopExit
        ;gameBoard = new Byte[4,4]
        push eax
        xor eax,eax
        mov dword [gameBoard+00h],eax
        mov dword [gameBoard+04h],eax
        mov dword [gameBoard+08h],eax
        mov dword [gameBoard+0Ch],eax
        pop eax
        ;isPlayerOnesTurn = true;
        mov byte [isPlayerOnesTurn],0x01
        ;winnerStatus = 0;
        mov byte [winnerStatus],0x00
        ;while(winnerStatus = 0)
        whileWinnerStatusIsZeroLoopStart:
        cmp byte [winnerStatus],0x00
        jne whileWinnerStatusIsZeroLoopEnd
		    ;Console.WriteLine();
			mov eax,textNewline
			call consolePrint
            ;if(isPlayerOnesTurn)
            cmp byte [isPlayerOnesTurn],0x00
            je notIsPlayerOnesTurn
                ;Console.WriteLine(textPlayerOneTurn);
                mov eax,textPlayerOneTurn
                call consolePrint
                ;ticTacPlayerTurn();
                call ticTacPlayerTurn
                ;gameBoard[xCoord,yCoord]=1;
                movzx eax,byte [xCoord]
                add eax,gameBoard
                movzx ebx,byte [yCoord]
                mov byte [eax+ebx*4],0x01
                ;ticTacCheckForWinner();
                call ticTacCheckForWinner
            notIsPlayerOnesTurn:
            ;if(!isPlayerOnesTurn)
            cmp byte [isPlayerOnesTurn],0x00
            jne notIsPlayerTwosTurn
                ;Console.WriteLine(textPlayerTwoTurn);
                mov eax,textPlayerTwoTurn
                call consolePrint
                ;ticTacPlayerTurn();
                call ticTacPlayerTurn
                ;gameBoard[xCoord,yCoord]=2;
                movzx eax,byte [xCoord]
                add eax,gameBoard
                movzx ebx,byte [yCoord]
                mov byte [eax+ebx*4],0x02
                ;ticTacCheckForWinner();
                call ticTacCheckForWinner
            notIsPlayerTwosTurn:
            ;isPlayerOnesTurn = !isPlayerOnesTurn
            push eax
            xor eax,eax
            mov al,byte [isPlayerOnesTurn]
            xor al,0x01
            mov byte [isPlayerOnesTurn],al
            pop eax
            jmp whileWinnerStatusIsZeroLoopStart
        whileWinnerStatusIsZeroLoopEnd:
        call ticTacPrintBoard
        ;if(winnerStatus==1)
        cmp byte [winnerStatus],0x01
        jne winnerStatusNotOne
            ;WriteLine(textWinnerPlayerOne);
            mov eax,textWinnerPlayerOne
            call consolePrint
        winnerStatusNotOne:
        ;if(winnerStatus==2)
        cmp byte [winnerStatus],0x02
        jne winnerStatusNotTwo
            ;WriteLine(textWinnerPlayerTwo);
            mov eax,textWinnerPlayerTwo
            call consolePrint
        winnerStatusNotTwo:
        ;if(winnerStatus==3)
        cmp byte [winnerStatus],0x03
        jne winnerStatusNotThree
            ;WriteLine(textWinnerPlayerTie);
            mov eax,textWinnerPlayerTie
            call consolePrint
        winnerStatusNotThree:
        ;WriteLine(textPlayAgain);
        mov eax,textPlayAgain
        call consolePrint
        ;didGiveValidInput = false;
        mov byte [didGiveValidInput],0x00
        ;while(!didGiveValidInput)
        endGameLoop:
        cmp byte [didGiveValidInput],0x01
        je endGameLoopEnd
            ;inputBuffer = ReadLine();
            mov eax,inputBuffer
            call consoleRead
            ;if(inputBuffer[0] == 'y')
            cmp byte [inputBuffer],0x79
            jne inputBufferNotlowerY
                ;doesWantToContinue = true;
                mov byte [doesWantToContinue],0x01
                ;didGiveValidInput = true;
                mov byte [didGiveValidInput],0x01
            inputBufferNotlowerY:
            ;if(inputBuffer[0] == 'Y')
            cmp byte [inputBuffer],0x59
            jne inputBufferNotUpperY
                ;doesWantToContinue = true;
                mov byte [doesWantToContinue],0x01
                ;didGiveValidInput = true;
                mov byte [didGiveValidInput],0x01
            inputBufferNotUpperY:
            ;if(inputBuffer[0] == 'n')
            cmp byte [inputBuffer],0x6E
            jne inputBufferNotlowerN
                ;doesWantToContinue = false;
                mov byte [doesWantToContinue],0x00
                ;didGiveValidInput = true;
                mov byte [didGiveValidInput],0x01
            inputBufferNotlowerN:
            ;if(inputBuffer[0] == 'N')
            cmp byte [inputBuffer],0x4E
            jne inputBufferNotUpperN
                ;doesWantToContinue = false;
                mov byte [doesWantToContinue],0x00
                ;didGiveValidInput = true;
                mov byte [didGiveValidInput],0x01
            inputBufferNotUpperN:
            jmp endGameLoop
        endGameLoopEnd:
        jmp whileDoesWantToContiueLoop
    whileDoesWantToContiueLoopExit:
    jmp exit

;eax: x of the requested location (1, 2, or 3)
;ebx: y of the requested location (A, B, or C)
;Returns ASCII char of the marker. Returns in eax
ticTacGetASCIIatXY:
    ;//setup
    add eax,gameBoard
    ;if (board[x, y] == 1)
    cmp byte [eax+ebx*4],0x01
    jne boardLocationNotOne
        ;return 'X'
        mov eax,0x58
        ret
    boardLocationNotOne:
    ;if (board[x, y] == 2)
    cmp byte [eax+ebx*4],0x02
    jne boardLocationNotTwo
        ;return 'O'
        mov eax,0x4F
        ret
    boardLocationNotTwo:
    ;return ' '
    mov eax,0x20
    ret

;No parameters
;Returns nothing
ticTacPlayerTurn:
    ;ticTacPrintBoard();
    call ticTacPrintBoard
    ;Console.WriteLine(textInstructions);
    mov eax,textInstructions
    call consolePrint
    ;didGiveValidInput = false;
    mov byte [didGiveValidInput],0x00
    ;while (!didGiveValidInput)
    ticTacPlayerTurnWhileDidNotGiveValidInputLoopStart:
    cmp byte [didGiveValidInput],0x00
    jne ticTacPlayerTurnWhileDidNotGiveValidInputLoopEnd
        ;inputBuffer = Console.ReadLine();
        mov eax,inputBuffer
        call consoleRead
        ;xCoord = asciiToX(inputBuffer[1]);
        mov al,[inputBuffer+1]
        call ticTacASCIItoX
        mov byte [xCoord],al
        ;yCoord = asciiToY(inputBuffer[0]);
        mov al,[inputBuffer+0]
        call ticTacASCIItoY
        mov byte [yCoord],al
        ;if (xCoord != 0xFF)
        cmp byte [xCoord],0xFF
        je ticTacPlayerTurnInputBad
            ;if (yCoord != 0xFF)
            cmp byte [yCoord],0xFF
            je ticTacPlayerTurnInputBad
                ;if (isSpaceClear(xCoord, yCoord))
                movzx eax,byte [xCoord]
                movzx ebx,byte [yCoord]
                call ticTacIsSpaceClear
                cmp al,01
                jne ticTacPlayerTurnInputBad
				    ;didGiveValidInput = true;
                    mov byte [didGiveValidInput],0x01
        ticTacPlayerTurnInputBad:
        jmp ticTacPlayerTurnWhileDidNotGiveValidInputLoopStart
    ticTacPlayerTurnWhileDidNotGiveValidInputLoopEnd:
    ret

;No parameters
;Returns nothing
ticTacCheckForWinner:
    ;This function was generated using nested for loops to create the logic and the jumps. 
    mov eax,0
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneHorizontalOne
        mov eax,0
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneHorizontalOne
            mov eax,0
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneHorizontalOne
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneHorizontalOne:
    mov eax,1
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneHorizontalTwo
        mov eax,1
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneHorizontalTwo
            mov eax,1
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneHorizontalTwo
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneHorizontalTwo:
    mov eax,2
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneHorizontalThree
        mov eax,2
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneHorizontalThree
            mov eax,2
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneHorizontalThree
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneHorizontalThree:
    mov ebx,0
    mov eax,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneVerticalOne
        mov ebx,0
        mov eax,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneVerticalOne
            mov ebx,0
            mov eax,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneVerticalOne
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneVerticalOne:
    mov ebx,1
    mov eax,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneVerticalTwo
        mov ebx,1
        mov eax,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneVerticalTwo
            mov ebx,1
            mov eax,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneVerticalTwo
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneVerticalTwo:
    mov ebx,2
    mov eax,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneVerticalThree
        mov ebx,2
        mov eax,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneVerticalThree
            mov ebx,2
            mov eax,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneVerticalThree
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneVerticalThree:
    mov eax,0
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneDiagonalOne
        mov eax,1
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneDiagonalOne
            mov eax,2
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneDiagonalOne
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneDiagonalOne:
    mov eax,2
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,1
    jne notPlayerOneDiagonalTwo
        mov eax,1
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,1
        jne notPlayerOneDiagonalTwo
            mov eax,0
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,1
            jne notPlayerOneDiagonalTwo
                jmp ticTacCheckForEndWinnerOne
    notPlayerOneDiagonalTwo:
    jmp notWinnerYetPlayerOne
    ticTacCheckForEndWinnerOne:
    mov byte [winnerStatus],1
    jmp ticTacCheckForWinnerExit
    notWinnerYetPlayerOne:
    mov eax,0
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoHorizontalOne
        mov eax,0
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoHorizontalOne
            mov eax,0
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoHorizontalOne
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoHorizontalOne:
    mov eax,1
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoHorizontalTwo
        mov eax,1
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoHorizontalTwo
            mov eax,1
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoHorizontalTwo
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoHorizontalTwo:
    mov eax,2
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoHorizontalThree
        mov eax,2
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoHorizontalThree
            mov eax,2
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoHorizontalThree
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoHorizontalThree:
    mov ebx,0
    mov eax,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoVerticalOne
        mov ebx,0
        mov eax,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoVerticalOne
            mov ebx,0
            mov eax,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoVerticalOne
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoVerticalOne:
    mov ebx,1
    mov eax,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoVerticalTwo
        mov ebx,1
        mov eax,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoVerticalTwo
            mov ebx,1
            mov eax,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoVerticalTwo
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoVerticalTwo:
    mov ebx,2
    mov eax,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoVerticalThree
        mov ebx,2
        mov eax,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoVerticalThree
            mov ebx,2
            mov eax,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoVerticalThree
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoVerticalThree:
    mov eax,0
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoDiagonalOne
        mov eax,1
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoDiagonalOne
            mov eax,2
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoDiagonalOne
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoDiagonalOne:
    mov eax,2
    mov ebx,0
    call ticTacGetValueAtXY
    cmp al,2
    jne notPlayerTwoDiagonalTwo
        mov eax,1
        mov ebx,1
        call ticTacGetValueAtXY
        cmp al,2
        jne notPlayerTwoDiagonalTwo
            mov eax,0
            mov ebx,2
            call ticTacGetValueAtXY
            cmp al,2
            jne notPlayerTwoDiagonalTwo
                jmp ticTacCheckForEndWinnerTwo
    notPlayerTwoDiagonalTwo:
    jmp notWinnerYetPlayerTwo
    ticTacCheckForEndWinnerTwo:
    mov byte [winnerStatus],2
    jmp ticTacCheckForWinnerExit
    notWinnerYetPlayerTwo:
    mov eax, 0
    mov ebx, 0
    call ticTacGetValueAtXY
    cmp al, 0
    je ticTacCheckForWinnerExit
        mov eax, 0
        mov ebx, 1
        call ticTacGetValueAtXY
        cmp al, 0
        je ticTacCheckForWinnerExit
            mov eax, 0
            mov ebx, 2
            call ticTacGetValueAtXY
            cmp al, 0
            je ticTacCheckForWinnerExit
                mov eax, 1
                mov ebx, 0
                call ticTacGetValueAtXY
                cmp al, 0
                je ticTacCheckForWinnerExit
                    mov eax, 1
                    mov ebx, 1
                    call ticTacGetValueAtXY
                    cmp al, 0
                    je ticTacCheckForWinnerExit
                        mov eax, 1
                        mov ebx, 2
                        call ticTacGetValueAtXY
                        cmp al, 0
                        je ticTacCheckForWinnerExit
                            mov eax, 2
                            mov ebx, 0
                            call ticTacGetValueAtXY
                            cmp al, 0
                            je ticTacCheckForWinnerExit
                                mov eax, 2
                                mov ebx, 1
                                call ticTacGetValueAtXY
                                cmp al, 0
                                je ticTacCheckForWinnerExit
                                    mov eax, 2
                                    mov ebx, 2
                                    call ticTacGetValueAtXY
                                    cmp al, 0
                                    je ticTacCheckForWinnerExit
    mov byte [winnerStatus],3
    ticTacCheckForWinnerExit:
    ret

;eax: ASCII of input
;Returns x value of inputted ASCII. Returns in eax
ticTacASCIItoX:
    sub al,0x31
	cmp al,0x02
	ja ticTacASCIItoXAbove
	    ret
	ticTacASCIItoXAbove:
	mov eax,0xFF
	ret

;eax: ASCII of input
;Returns y value of inputted ASCII. Returns in eax
ticTacASCIItoY:
	push ebx
	mov ebx,eax

	sub al,0x41
	cmp al,0x02
	ja ticTacASCIItoYNotUppercase
	    pop ebx
	    ret
	ticTacASCIItoYNotUppercase:
	
	mov eax,ebx
	sub al,0x61
	cmp al,0x02
	ja ticTacASCIItoYNotLowercase
	    pop ebx
		ret
	ticTacASCIItoYNotLowercase:
	
	mov eax,0xFF
	pop ebx
	ret

;eax: x of location to check
;ebx: y of location to check
;Returns boolean of whether space is clear. Returns in eax
ticTacIsSpaceClear:
    call ticTacGetValueAtXY
    cmp al,0x00
    jne ticTacIsSpaceClearFalse
        ;return 1;
        mov eax,0x01
        ret
    ticTacIsSpaceClearFalse:
    ;return 0;
    mov eax,0x00
    ret

;eax: x value of location to get
;ebx: y value of location to get
ticTacGetValueAtXY:
    add eax,gameBoard
    movzx eax,byte [eax+ebx*4]
    ret
    

;No parameters
;Returns nothing
ticTacPrintBoard:
    push eax
    push ebx
    ;Console.Write(topRow);
    mov eax,textTopRow
    call consolePrint
    
    ;//Print First Row
    ;Console.Write(textFirstRow);
    mov eax,textFirstRow
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(0, 0));
    mov eax,0
    mov ebx,0
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textSpace);
    mov eax,textSpace
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(1, 0));
    mov eax,1
    mov ebx,0
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textSpace);
    mov eax,textSpace
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(2, 0));
    mov eax,2
    mov ebx,0
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textNewline);
    mov eax,textNewline
    call consolePrint
    
    ;//Print Second Row
    ;Console.Write(textSecondRow);
    mov eax,textSecondRow
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(0, 1));
    mov eax,0
    mov ebx,1
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textSpace);
    mov eax,textSpace
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(1, 1));
    mov eax,1
    mov ebx,1
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textSpace);
    mov eax,textSpace
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(2, 1));
    mov eax,2
    mov ebx,1
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textNewline);
    mov eax,textNewline
    call consolePrint
    
    ;//Print Third Row
    ;Console.Write(textThirdRow);
    mov eax,textThirdRow
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(0, 2));
    mov eax,0
    mov ebx,2
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textSpace);
    mov eax,textSpace
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(1, 2));
    mov eax,1
    mov ebx,2
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textSpace);
    mov eax,textSpace
    call consolePrint
    ;Console.Write(ticTacGetASCIIatXY(2, 2));
    mov eax,2
    mov ebx,2
    call ticTacGetASCIIatXY
    mov byte [charBuffer],al
    mov eax,charBuffer
    call consolePrint
    ;Console.Write(textNewline);
    mov eax,textNewline
    call consolePrint
    pop ebx
    pop eax
    ret

;eax: address of string to print
;Returns nothing
consolePrint:
    push ebx
    push ecx
    push edx
    ;edx = length of string
    xor edx,edx
    printLoop:
    cmp byte [eax+edx],00
    je printLoopEnd
        inc edx
        jmp printLoop
    printLoopEnd:
    ;ecx = address of text
    mov ecx,eax
    ;ebx = 1
    mov ebx,1
    ;eax = 4
    mov eax,4
    int 80h
    pop edx
    pop ecx
    pop ebx
    ret

;eax: address of where to write incoming string
;Returns nothing
consoleRead:
    push ebx
    push ecx
    push edx
    ;edx = length of string
    mov edx,64
    ;ecx = address of text
    mov ecx,eax
    ;ebx = 1
    mov ebx,1
    ;eax = 3
    mov eax,3
    int 80h
    pop edx
    pop ecx
    pop ebx
    ret

exit:
    mov eax,1
    mov ebx,0
    int 80h

;;TESTING DEBUG
;push eax
;mov eax,textInstructions
;call consolePrint
;pop eax
;;TESTING DEBUG