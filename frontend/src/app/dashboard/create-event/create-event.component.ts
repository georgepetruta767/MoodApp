import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {PeopleService} from "../common/services/people.service";
import {PersonModel} from "../common/models/person.model";
import {EventsService} from "../common/services/events.service";

@Component({
  selector: 'app-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.scss'],
})
export class CreateEventComponent implements OnInit {
  public form!: FormGroup;

  public people!: Array<PersonModel>;

  constructor(private peopleService: PeopleService,
              private eventsService: EventsService) { }

  async ngOnInit() {
    this.setupForm();
    await this.getAllPeople();
  }

  private setupForm() {
    this.form = new FormGroup({
      title: new FormControl('', [Validators.required]),
      people: new FormControl(),
      eventDate: new FormControl('', [Validators.required])
    })
  }

  public async getAllPeople() {
    this.people = await this.peopleService.getPeople();
  }

  public async addEvent() {
    if(this.form.valid) {
      await this.eventsService.addEvent({
        title: this.form.controls.title.value,
        peopleIds: this.form.controls.people.value.map(x => x.id),
        date: this.form.controls.eventDate.value
      });
    }
  }
}
