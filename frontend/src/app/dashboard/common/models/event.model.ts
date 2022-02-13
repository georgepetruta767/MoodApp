import {EventStatus} from "../enums/event-status";

export class EventModel {
  public id?: string;
  public title!: string;
  public peopleIds!: Array<string>;
  public date!: Date;
  public status: EventStatus;
}
