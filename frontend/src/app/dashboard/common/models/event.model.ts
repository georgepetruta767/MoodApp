import {EventStatus} from '../enums/event-status.enum';
import {EventType} from '../enums/event-type.enum';
import {PersonModel} from './person.model';
import {Season} from '../enums/season.enum';
import {LocationModel} from './location.model';

export class EventModel {
  public id?: string;
  public title!: string;
  public people!: Array<PersonModel>;
  public startingTime!: Date;
  public endingTime?: Date;
  public status!: EventStatus;
  public type: EventType;
  public amountSpent?: number;
  public location?: LocationModel;
  public grade?: number;
  public season?: Season;
}
