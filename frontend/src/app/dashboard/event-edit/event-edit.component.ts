import {Component, OnInit} from '@angular/core';
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
export class EventEditComponent implements OnInit {
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

  public today = new Date().toISOString();

  constructor(private peopleService: PeopleService,
              private eventsService: EventsService,
              private router: Router,
              private activatedRoute: ActivatedRoute) { }

  async ngOnInit() {
  }

  private setupForm() {
    this.form = new FormGroup({
      title: new FormControl(this.eventToEdit ? this.eventToEdit.title : '', [Validators.required]),
      people: new FormControl(),
      eventDate: new FormControl('', [Validators.required]),
      type: new FormControl('', [Validators.required])
    })
  }

  public async getAllPeople() {
    this.people = await this.peopleService.getPeople();
  }

  public async addEvent() {
    if(this.form.valid) {
      await this.eventsService.addEvent({
        title: this.form.controls.title.value,
        people: this.form.controls.people.value,
        startingTime: this.form.controls.eventDate.value,
        status: EventStatus.Incoming,
        type: Number(this.form.controls.type.value)
      }).then(() => {
        this.router.navigateByUrl('calendar');
      });
    }
  }

  public getPersonName(person: PersonModel) {
    return `${person.firstName} ${person.lastName}`;
  }

  public getButtonLabel() {
    return this.eventToEdit ? 'Save' : 'Add';
  }
}
