#MenuMaskKey vk07
SysGet, MonitorCount, MonitorCount
SysGet, Mon1, Monitorworkarea, 1 
if monitorcount>1
	SysGet, Mon2, Monitorworkarea, 2

; print for debug
; MsgBox, Left: %mon1left% -- Top: %mon1top% -- Right: %Mon1Right% -- Bottom %Mon1Bottom%.
; MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom %Mon2Bottom%.

mgn := 8 ; margin
b := mon1bottom + mgn ; both monitors should have same bottom
t := -2
step := 200 ; # of pixels to move/resize per command

; get dimensions of current monitor
; assumes monitors are horizontally adjacent
Dim(ByRef l, ByRef r) {
    global mgn
    global monitorcount, mon1left, mon1right, mon2left, mon2right
    if (monitorcount > 1) {
        WinGetPos, X, Y, dx, dy, A ; figure out which monitor we're on
        ; MsgBox, %X% %Y% %dx% %dy%
        l := min((x+dx//2) // max(mon1left, mon2left), 1) * max(mon1left, mon2left)
        if (l = mon1left) {
            r := mon1right + mgn
        }
        else {
            r := mon2right + mgn
        }
        l := l - mgn
    }
    else {
        l := mon1left - mgn
        r := mon1right + mgn
    }
    ; MsgBox, %l% %r%
    return
}

MoveWindow(dir) {
    global b, t, step
    global monitorcount, mon1left, mon1right, mon2left, mon2right
    WinGetPos, X, Y, dx, dy, A
    WinGet, s, MinMax, A
    if (s = 1) {
        return
    }
    Dim(l, r)
    if (dir = "l") {
        newx := max(l, X - step)
        newy := y
    }
    else if (dir = "r") {
        newx := min(r - dx, X + step)
        newy := y
    }
    else if (dir = "u") {
        newx := x
        newy := max(t, Y - step)
    }
    else if (dir = "d") {
        newx := x
        newy := min(b - dy, Y + step)
    }
    else {
        return
    }
    WinMove, A, , newx, newy
    return
}

; full screen
#!f::
Dim(l, r)
WinRestore, A
WinMove, A, , l, 0, (r-l), b ; have to move window anyways, to preserve dimensions
WinMaximize, A ; then maximize
return

; center
#!c::
Dim(l, r)
WinRestore, A
WinMove, A, , (5*l+r)/6, (5*t+b)/6, 2*(r-l)/3, 2*(b-t)/3
return

; small center
#!+c::
Dim(l, r)
WinRestore, A
WinMove, A, , (3*l+r)/4, b/4, (r-l)/2, (b-t)/2
return

; left half
#!Left::
Dim(l, r)
WinRestore, A
WinMove, A, , l, t, (r-l)/2 + mgn, b-t
return

; right half
#!Right::
Dim(l, r)
WinRestore, A
WinMove, A, , (l+r)/2 - mgn, t, (r-l)/2 + mgn, b-t
return

; top half
#!Up::
Dim(l, r)
WinRestore, A
WinMove, A, , l, t, r-l, (b-t)/2 + mgn/2
return

; bottom half
#!Down::
Dim(l, r)
WinRestore, A
WinMove, A, , l, (t+b)/2 - mgn/2, r-l, (b-t)/2 + mgn/2
return

; top left
^!Left::
Dim(l, r)
WinRestore, A
WinMove, A, , l, t, (r-l)/2 + mgn, (b-t)/2 + mgn/2
return

; top right
^!Right::
Dim(l, r)
WinRestore, A
WinMove, A, , (l+r)/2 - mgn, t, (r-l)/2 + mgn, (b-t)/2 + mgn/2
return

; bottom left
^!+Left::
Dim(l, r)
WinRestore, A
WinMove, A, , l, (t+b)/2 - mgn/2, (r-l)/2 + mgn, (b-t)/2 + mgn/2
return

; bottom right
^!+Right::
Dim(l, r)
WinRestore, A
WinMove, A, , (l+r)/2 - mgn, (t+b)/2 - mgn/2, (r-l)/2 + mgn, (b-t)/2 + mgn/2
return

; move screen to right monitor (mon1)
^#Right::
if (monitorcount > 1) {
    WinGet, s, MinMax, A
    WinGetPos, X, Y, , , A
    WinRestore, A
    Dim(l, r)
    WinMove, A, , (x - l) + mon1left - mgn, Y, ,
    if (s = 1) { ; window was maximized
        WinMaximize, A
    }
}
return

; move screen to left monitor (mon2)
^#Left::
if (monitorcount > 1) {
    WinGetPos, X, Y, , , A
    WinGet, s, MinMax, A
    WinRestore, A
    Dim(l, r)
    WinMove, A, , (x - l) + mon2left - mgn, Y, ,
    if (s = 1) { ; window was maximized
        WinMaximize, A
    }
}
return

; enlarge window
^#Up::
WinGetPos, X, Y, dx, dy, A
WinRestore, A
Dim(l, r)
newx := max(x - step//2, l)
newy := max(y - step//2, 0)
newdx := min(dx + step, r - newx)
newdy := min(dy + step, b - newy)
WinMove, A, , newx, newy, newdx, newdy
return

; shrink window
^#Down::
WinGetPos, X, Y, dx, dy, A
WinRestore, A
Dim(l, r)
ms := 3 ; minimum window size in terms of # of steps
newx := min(x + step//2, x + dx // 2 - (ms * step) // 2)
newy := min(y + step//2, y + dy // 2 - (ms * step) // 2)
newdx := max(dx - step, ms * step)
newdy := max(dy - step, ms * step)
WinMove, A, , newx, newy, newdx, newdy
return

; window movement
^#!Left::
MoveWindow("l")
return

^#!Right::
MoveWindow("r")
return

^#!Up::
MoveWindow("u")
return

^#!Down::
MoveWindow("d")
return