import {Component} from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {PeopleService} from "../common/services/people.service";
import {PersonModel} from "../common/models/person.model";
import {EventsService} from "../common/services/events.service";
import {EventStatus} from "../common/enums/event-status.enum";
import {ActivatedRoute, Router} from "@angular/router";
import {EventModel} from "../common/models/event.model";

@Component({
  selector: 'app-event-edit',
  templateUrl: './event-edit.component.html',
  styleUrls: ['./event-edit.component.scss'],
})

export class EventEditComponent {
  public async ionViewWillEnter() {
    if(this.form)
      this.form.reset();

    await this.getAllPeople();

    if(this.activatedRoute.snapshot.params.id) {
      this.eventToEdit = await this.eventsService.getEventById(this.activatedRoute.snapshot.params.id);
    }

    this.setupForm();
  }

  public eventToEdit: EventModel;

  public form!: FormGroup;

  public people!: Array<PersonModel>;

  constructor(private peopleService: PeopleService,
              private eventsService: EventsService,
              private router: Router,
              private activatedRoute: ActivatedRoute) { }

  public get today() {
    return new Date().toISOString();
  }

  public formatEventTime(date: Date) {
    if(date)
      return new Date(date).toLocaleDateString(navigator.language, {day: '2-digit', month: "long", year: "numeric"});
    return '';
  }

  private setupForm() {
    this.form = new FormGroup({
      title: new FormControl(this.eventToEdit ? this.eventToEdit.title : '', [Validators.required]),
      people: new FormControl(this.eventToEdit ? this.eventToEdit.people.map(x => x.id) : ''),
      eventDate: new FormControl(this.eventToEdit ? this.eventToEdit.startingTime : '', [Validators.required]),
      type: new FormControl(this.eventToEdit ? this.eventToEdit.type : '', [Validators.required])
    })
  }

  public async getAllPeople() {
    this.people = await this.peopleService.getPeople();
  }

  public async addEvent() {
    if(this.form.valid) {
      const eventModel = {
        id: this.eventToEdit?.id,
        title: this.form.controls.title.value,
        people: this.form.controls.people.value.map(x => this.people.find(y => y.id === x)),
        startingTime: this.form.controls.eventDate.value,
        status: EventStatus.Incoming,
        type: Number(this.form.controls.type.value)
      };

      this.eventToEdit ? await this.eventsService.updateEvent(eventModel) : await this.eventsService.addEvent(eventModel);

      await this.router.navigateByUrl('calendar');
    }
  }

  public getPersonName(person: PersonModel) {
    return `${person.firstName} ${person.lastName}`;
  }

  public getButtonLabel() {
    return this.eventToEdit ? 'Save' : 'Add';
  }
}
