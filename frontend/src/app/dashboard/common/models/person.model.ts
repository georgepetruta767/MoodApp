import {Gender} from "../enums/gender.enum";
import {SocialStatus} from "../enums/social-status.enum";

export class PersonModel {
  public id?: string;
  public firstName!: string;
  public lastName!: string;
  public age!: number;
  public gender!: Gender;
  public socialStatus: SocialStatus;
}
