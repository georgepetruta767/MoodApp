import {Component, ViewChild} from '@angular/core';
import {EventModel} from '../common/models/event.model';
import {EventsService} from '../common/services/events.service';
import {FormControl, FormGroup} from '@angular/forms';
import {CalendarComponentOptions, DayConfig} from 'ion5-calendar';
import {IonContent} from '@ionic/angular';

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})

export class PlannerComponent {
  @ViewChild('content')
  public content: IonContent;

  public calendarConfig!: CalendarComponentOptions;

  public dateForm!: FormGroup;

  public isEventsListVisible = false;

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService) { }

  public async ionViewWillEnter(){
    this.isEventsListVisible = false;

    await this.loadEvents();

    this.setupCalendar();

    this.setupForm();

    this.dateForm.controls.selectedDate.valueChanges.subscribe(async () => {
      await this.showEventsList();
      setTimeout(async () => {
        await this.content.scrollToBottom(300);
      }, 100);
    });
  }

  public setupForm() {
    this.dateForm = new FormGroup({
      selectedDate: new FormControl()
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
      });
    });

    this.calendarConfig = {
      showToggleButtons: true,
      showMonthPicker: true,
      from: new Date(1),
      daysConfig
    };
  }

  public async showEventsList() {
    if(this.calendarConfig.daysConfig.find(x => x.date.toString().slice(0, 10) === this.dateForm.controls.selectedDate.value)) {
      this.isEventsListVisible = true;
    }
  }
}
