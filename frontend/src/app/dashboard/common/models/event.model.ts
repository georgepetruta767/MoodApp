import {EventStatus} from "../enums/event-status";

export class EventModel {
  public id?: string;
  public title!: string;
  public peopleIds!: Array<string>;
  public startingTime!: Date;
  public status: EventStatus;
  public amountSpent?: number;
}
