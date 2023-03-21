abstract class LocationStates{}
class LocationInitialState extends LocationStates{}
class LocationEnabledSuccess extends LocationStates{}
class GetCurrentLocationSuccess extends LocationStates{}
class GetCurrentLocationError extends LocationStates
{
  final error;
  GetCurrentLocationError(this.error);
}
class GetPositionSuccess extends LocationStates{}
class MoodChangesSuccessfully extends LocationStates{}
class DarkMapMood extends LocationStates{}
class LightMapMood extends LocationStates{}
class ChangeLocation extends LocationStates{}
class LiveLocation extends LocationStates{}
class ButtonDisappeared extends LocationStates{}
class AddPolyline extends LocationStates{}
class ServiceClickedSuccessfully extends LocationStates{}
class RemovedSuccessfully extends LocationStates{}



