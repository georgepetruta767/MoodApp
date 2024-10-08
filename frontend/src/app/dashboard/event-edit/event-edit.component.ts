import {Component} from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {PeopleService} from '../common/services/people.service';
import {PersonModel} from '../common/models/person.model';
import {EventsService} from '../common/services/events.service';
import {EventStatus} from '../common/enums/event-status.enum';
import {ActivatedRoute, Router} from '@angular/router';
import {EventModel} from '../common/models/event.model';
import {Season} from '../common/enums/season.enum';

@Component({
  selector: 'app-event-edit',
  templateUrl: './event-edit.component.html',
  styleUrls: ['./event-edit.component.scss'],
})

export class EventEditComponent {
  public eventToEdit: EventModel;

  public selectedDate: Date;

  public form!: FormGroup;

  public people!: Array<PersonModel>;

  constructor(private peopleService: PeopleService,
              private eventsService: EventsService,
              private router: Router,
              private activatedRoute: ActivatedRoute) { }

  public get today() {
    return new Date().toISOString();
  }

  public async ionViewWillEnter() {
    this.setupForm();

    await this.getAllPeople();

    if(this.activatedRoute.snapshot.params.date) {
      this.selectedDate = new Date(this.activatedRoute.snapshot.params.selectedDate);
    }

    if(this.activatedRoute.snapshot.params.id) {
      this.eventToEdit = await this.eventsService.getEventById(this.activatedRoute.snapshot.params.id);
    }

    this.setupForm();
  }

  public formatEventTime(date: Date) {
    if(date) {
      return new Date(date).toLocaleDateString(navigator.language, {day: '2-digit', month: 'long', year: 'numeric'});
    }
    return '';
  }

  public async addEvent() {
    if(! this.form.valid) {
      return;
    }

    const month = new Date(this.form.controls.eventDate.value).getMonth() + 1;
    let season;
    switch(month) {
      case 12:
      case 1:
      case 2:
        season = Season.Winter;
        break;
      case 3:
      case 4:
      case 5:
        season = Season.Spring;
        break;
      case 6:
      case 7:
      case 8:
        season = Season.Summer;
        break;
      case 9:
      case 10:
      case 11:
        season = Season.Autumn;
        break;
    }

    const eventModel = {
      id: this.eventToEdit?.id,
      title: this.form.controls.title.value,
      people: this.form.controls.people.value ? this.form.controls.people.value.map(x => this.people.find(y => y.id === x)) : [],
      startingTime: this.form.controls.eventDate.value,
      status: this.eventToEdit ? this.eventToEdit.status : EventStatus.Incoming,
      season: this.eventToEdit ? this.eventToEdit.season : season,
      type: this.eventToEdit ? this.eventToEdit.type : Number(this.form.controls.type.value),
      grade: this.eventToEdit ? this.eventToEdit.grade : null,
      amountSpent: this.eventToEdit ? this.eventToEdit.amountSpent : null,
      endingTime: this.eventToEdit ? this.eventToEdit.endingTime : null,
    };

    this.eventToEdit ? await this.eventsService.updateEvent(eventModel) : await this.eventsService.addEvent(eventModel);

    await this.router.navigateByUrl('calendar');
  }

  public getPersonName(person: PersonModel) {
    return `${person.firstName} ${person.lastName}`;
  }

  public getButtonLabel() {
    return this.eventToEdit ? 'Save' : 'Add';
  }

  private setupForm() {
    this.form = new FormGroup({
      title: new FormControl(this.eventToEdit ? this.eventToEdit.title : '', [Validators.required]),
      people: new FormControl(this.eventToEdit ? this.eventToEdit.people.map(x => x.id) : ''),
      eventDate: new FormControl(this.eventToEdit ? this.eventToEdit.startingTime : '', [Validators.required]),
      type: new FormControl(this.eventToEdit ? this.eventToEdit.type : '', [Validators.required])
    });
  }

  private async getAllPeople() {
    this.people = await this.peopleService.getPeople();
  }
}
