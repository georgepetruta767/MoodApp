import {EventStatus} from "../enums/event-status.enum";
import {EventType} from "../enums/event-type.enum";
import {PersonModel} from "./person.model";
import {Season} from "../enums/season.enum";

export class EventModel {
  public id?: string;
  public title!: string;
  public people!: Array<PersonModel>;
  public startingTime!: Date;
  public endingTime?: Date;
  public status!: EventStatus;
  public type: EventType;
  public amountSpent?: number;
  public locationId?: string;
  public grade?: number;
  public season?: Season
}
