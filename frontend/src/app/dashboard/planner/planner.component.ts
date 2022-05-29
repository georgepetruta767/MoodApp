import {Component, ViewChild} from '@angular/core';
import {EventModel} from '../common/models/event.model';
import {EventsService} from '../common/services/events.service';
import {FormControl, FormGroup} from '@angular/forms';
import {CalendarComponentOptions, DayConfig} from 'ion5-calendar';
import {IonContent} from '@ionic/angular';
import {EventsListComponent} from './events-list/events-list.component';

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})

export class PlannerComponent {
  @ViewChild('content')
  public content: IonContent;

  @ViewChild(EventsListComponent, { static: true })
  public eventsList: EventsListComponent;

  public calendarConfig!: CalendarComponentOptions;

  public dateForm!: FormGroup;

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService) { }

  public async ionViewWillEnter() {
    await this.loadEvents();

    this.setupCalendar();

    this.setupForm();

    this.dateForm.controls.selectedDate.valueChanges.subscribe(async () => {
      console.log(this.eventsList)

      setTimeout(async () => {
        await this.content.scrollToBottom(300);
        //scrollToBottom(300);
      }, 100);
    });
  }

  private setupCalendar() {
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

  private setupForm() {
    this.dateForm = new FormGroup({
      selectedDate: new FormControl()
    });
  }

  private async loadEvents() {
    this.events = await this.eventsService.getEvents();
  }
}
