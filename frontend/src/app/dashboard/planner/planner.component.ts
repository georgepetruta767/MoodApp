import {Component, ViewChild} from '@angular/core';
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";
import {FormControl, FormGroup} from "@angular/forms";
import {IonContent} from "@ionic/angular";
import {CalendarComponentOptions, DayConfig} from "ion5-calendar";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})

export class PlannerComponent {
  @ViewChild('content', { static: true })
  public content: IonContent;

  public calendarConfig!: CalendarComponentOptions;

  public async ionViewWillEnter(){
    this.isEventsListVisible = false;

    await this.loadEvents();

    this.setupCalendar();

    this.setupForm();

    this.dateForm.controls.selectedDate.valueChanges.subscribe((x) => {
      this.showEventsList();
    })
  }

  public dateForm!: FormGroup;

  public isEventsListVisible = false;

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService) { }

  public setupForm() {
    this.dateForm = new FormGroup({
      'selectedDate': new FormControl()
    });
  }

  public async loadEvents() {
    this.events = await this.eventsService.getEvents();
  }

  public monthChange() {
    this.isEventsListVisible = false;
  }

  public setupCalendar() {
    const daysConfig = new Array<DayConfig>();
    this.events.forEach(event => {
      daysConfig.push({
        date: event.startingTime,
        cssClass: 'circled'
      })
    })

    this.calendarConfig = {
      showToggleButtons: true,
      showMonthPicker: true,
      from: new Date(1),
      daysConfig: daysConfig
    }
  }

  public async showEventsList() {
    await this.content.scrollToBottom(300);

    if(this.calendarConfig.daysConfig.find(x => x.date.toString().slice(0, 10) === this.dateForm.controls.selectedDate.value)) {
      this.isEventsListVisible = true;
    }
  }
}
