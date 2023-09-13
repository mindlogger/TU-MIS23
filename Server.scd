(
var window;
var slider;
var button;

var mAWindowsSize = 4;

var mAXP = 0;
var mAYP = 0;

var mAXA = Array.fill(mAWindowsSize,0);
var mAYA = Array.fill(mAWindowsSize,0);

var serverXValue = 0.3;
var serverYValue = 0.3;


var oscOutPorts = [NetAddr.new("AP-01", 69420), NetAddr.new("AP-03", 69420), NetAddr.new("AP-04", 69420), NetAddr.new("AP-05", 69420),NetAddr.new("AP-06", 69420),NetAddr.new("AP-08", 69420),NetAddr.new("AP-09", 69420),NetAddr.new("AP-10", 69420),NetAddr.new("AP-11", 69420),NetAddr.new("AP-12", 69420),NetAddr.new("AP-13", 69420), NetAddr.new("AP-14", 69420), NetAddr.new("192.168.14.172", 8000)];

var oscInPort = NetAddr.new("192.168.14.172", 69420);

thisProcess.openUDPPort(69420);

window = Window("Server", Rect(100,100, 440 ,440));
window.front;

slider = UserView(window, Rect(20, 20, 400, 400));
slider.background = Color.gray;

button = UserView(window, Rect(20, 20, 20, 20));
button.background = Color.green;

AppClock.sched(0.3, {
	button.moveTo(20 + (serverXValue * 380), 20 + (((serverYValue * -1)+1) * 380)); //GO FROM 20 to 400
	for(0,12) {arg i; oscOutPorts[i].sendMsg("/voteResult/x", serverXValue);};
	for(0,12) {arg i; oscOutPorts[i].sendMsg("/voteResult/y", serverYValue);};
	0.3;
});

~osc_receive = OSCFunc(

{ arg msg, time, addr, recvPort;
		mAXP = mAXP + 1;
		mAXP = if (mAXP < (mAWindowsSize), { mAXP }, {0});
		mAXA[mAXP] = msg[1];
		serverXValue = mAXA.sum / mAWindowsSize;
}, '/vote/ID/x');

~osc_receive = OSCFunc(

{ arg msg, time, addr, recvPort;
		mAYP = mAYP + 1;
		mAYP = if (mAYP < (mAWindowsSize), { mAYP }, {0});
		mAYA[mAXP] = msg[1];
		serverYValue = mAYA.sum / mAWindowsSize;
}, '/vote/ID/y');

window.onClose = {
	AppClock.clear;
	OSCFunc.clear;
};

//OSCFunc.trace(true);


slider.setProperty(\clipInBounds,0);
button.alwaysOnTop = true;
window.front;
NetAddr.langPort.postln;
)