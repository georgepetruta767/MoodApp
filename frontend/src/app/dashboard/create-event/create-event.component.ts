import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {PeopleService} from "../common/services/people.service";
import {PersonModel} from "../common/models/person.model";

@Component({
  selector: 'app-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.scss'],
})
export class CreateEventComponent implements OnInit {
  public form!: FormGroup;

  public people!: Array<PersonModel>;

  constructor(private peopleService: PeopleService) { }

  async ngOnInit() {
    this.setupForm();
    await this.getAllPeople();
  }

  private setupForm() {
    this.form = new FormGroup({
      title: new FormControl('', [Validators.required]),
      people: new FormControl(),
      startingTime: new FormControl('', [Validators.required])
    })
  }

  public async getAllPeople() {
    this.people = await this.peopleService.getPeople();
  }

  public async addEvent() {
    console.log(this.form.controls.startingTime.value);
  }
}
