%var4

boxIntersection(box(Xf1, Yf1, Xf2, Yf2), box(Xs1, Ys1, Xs2, Ys2), box(XInt1, YInt1, XInt2, YInt2)) :-
	XInt1 is max(Xf1, Xs1),
	YInt1 is max(Yf1, Ys1),
	XInt2 is min(Xf2, Xs2),
	YInt2 is min(Yf2, Ys2).

area(box(X1, Y1, X2, Y2), Area) :-
	X1 < X2,
	Y1 < Y2,
	Area is (X2 - X1) * (Y2 - Y1),
	!.
area(box(_, _, _, _), 0).


timeBetween(StartTime, FinishTime, Time) :-
	StartTime =< FinishTime,
	MaxTimeInt is FinishTime - StartTime,
	iter(0, 1, MaxTimeInt, TimeInt),
	Time is StartTime + TimeInt.

iter(MinIter, _Step, MaxIter, _Iter) :-
	MinIter > MaxIter,
	!, fail.
iter(MinIter, _Step, _MaxIter, MinIter).
iter(MinIter, Step, MaxIter, Iter) :-
	NextMinIter is MinIter + Step,
	iter(NextMinIter, Step, MaxIter, Iter).






%code
robbery(Victim, Robber1, Robber2, Vehicle, StartTime, EndTime) :-
	personIsSitting(Robber1, Vehicle, SittingTime1),
	personIsSitting(Robber2, Vehicle, SittingTime1),
	not(Robber1=Robber2),
	StartTime is SittingTime1 + 1,
	not(personIsSitting(Robber1, Vehicle, StartTime)),
	personIsSitting(Robber1, Vehicle, SittingTime2),
	personIsSitting(Robber2, Vehicle, SittingTime2),
	EndTime is SittingTime2 - 1,
	not(personIsSitting(Robber1, Vehicle, EndTime)),
	started(searchPockets(Robber1, Victim), StartSearchingTime),
	finished(searchPockets(Robber1, Victim), EndSearchingTime),
	StartTime < StartSearchingTime,
	EndSearchingTime < EndTime.

personIsSitting(Person, Vehicle, Time) :-
	person(Person, Time),
	vehicle(Vehicle, motorcycle, Time),
	bounds(Person, box(Xp1, Yp1, Xp2, Yp2), Time),
	bounds(Vehicle, box(Xv1, Yv1, Xv2, Yv2), Time),
	boxIntersectionPercent(box(Xp1, Yp1, Xp2, Yp2), box(Xv1, Yv1, Xv2, Yv2), PercentP),
	boxIntersectionPercent(box(Xv1, Yv1, Xv2, Yv2), box(Xp1, Yp1, Xp2, Yp2), PercentV),
	PercentP > 40/100,
	PercentV > 20/100.

boxIntersectionPercent(box(Xf1, Yf1, Xf2, Yf2), box(Xs1, Ys1, Xs2, Ys2), Percent) :-
	boxIntersection(box(Xf1, Yf1, Xf2, Yf2), box(Xs1, Ys1, Xs2, Ys2), box(X1, Y1, X2, Y2)),
	X1 < X2,
	Y1 < Y2,
	area(box(X1, Y1, X2, Y2), AreaI),
	area(box(Xf1, Yf1, Xf2, Yf2), Area1),
	Percent is AreaI/Area1.
